# Ayudantía 3: Asociaciones
**IIC2143-2020-1. Ayudante: Valentina Rojas**

Vamos a hacer una guía paso a paso de lo que nos faltó en la ayudantía de asociaciones. Recordar que tenemos las siguientes relaciones creadas:

```ruby
Song
belongs_to :album, :dependent => :destroy
has_and_belongs_to_many :playlists

Album
belongs_to :artist
has_many :songs

Artist
belongs_to :user
has_many :albums

User
has_one :artist
has_many :playlists, :dependent => :delete_all

Playlist
has_and_belongs_to_many :songs
belongs_to :user
```
En este resumen agregué un par de sentencias de dependencias que no encontrarán en el ejemplo subido, pero que les pueden ser útiles.

Durante la ayudantía vimos que existen tres pasos básicos a seguir para poder lograr que nuestros modelos efectivamente presenten las relaciones que queremos:

1. Asociaciones en el modelo
2. Anidar rutas
3. Cambios en los controladores y las vistas.

Alcanzamos a hacer esto para la relación **1:1** entre `User` y `Artist` y para crear álbumes en la relación **1:N** entre `Artist` y `Album`. Ahora veremos cómo crear canciones dentro de los álbumes y luego cómo crear playlists y agregarles canciones. Todo esto lo pueden probar por ustedes mismos en el ejemplo terminado que encontrarán en el repositorio del curso.

Recapitularemos rápidamente los primeros dos pasos que ya alcanzamos a ver

## 1. Asociaciones en el modelo
Como queremos que tanto nuestras `Playlists` como `Albums` tengan `Songs`, el primer paso **son las asociaciones en el modelo:**
```ruby
# /app/models/playlist.rb
class Playlist < ApplicationRecord
  has_many :songs, :dependent => :destroy
  belongs_to :user
end

# /app/models/song.rb
class Song < ApplicationRecord
  belongs_to :album, :dependent => :destroy
  has_and_belongs_to_many :playlists
end

# /app/models/album.rb
class Album < ApplicationRecord
belongs_to :artist
has_many :songs
end
```
Ahora, gracias a la magia de [Active Record]([https://guides.rubyonrails.org/active_record_basics.html](https://guides.rubyonrails.org/active_record_basics.html)) podemos usar funciones como `@playlist.songs`, siendo `@playlist` una variable donde guardamos la instancia de una lista de reproducción, y `songs` un iterable de todas las canciones que tienen la `id` de dicha playlist como *foreign key*. Análogamente, podemos acceder a `@album.songs`, `@song.album.artist.name`, etc.

## 2. Asociaciones en las rutas
Luego, debemos preocuparnos de las *routes*. Para ver las rutas que tienen disponibles actualmente, pueden usar el comando `rails routes`, `rake routes` o entrar a `localhost:3000/rails/info/routes`

Con esto, van a poder ver algo de esta forma (está acortado):

```bash
Prefix Verb URI Pattern  Controller#Action

playlist_songs GET  /playlists/:playlist_id/songs(.:format)  songs#index

POST /playlists/:playlist_id/songs(.:format)  songs#create

new_playlist_song GET  /playlists/:playlist_id/songs/new(.:format)  songs#new

edit_playlist_song GET  /playlists/:playlist_id/songs/:id/edit(.:format) songs#edit

playlist_song GET  /playlists/:playlist_id/songs/:id(.:format)  songs#show
```

La idea es que podamos crear canciones **dentro** de `albums`, por lo que buscamos que en vez de tener rutas separadas como `/albums/` -que sería el index de todas los albumes disponibles-, y `/songs/` que serían todas las canciones disponibles, tener algo como `albums/1/songs`, que serían todas las canciones creadas en el album con `id` 1 y lo mismo para `playlists`. Es por esto que el paso siguiente que hicimos fue **anidar las rutas**:

```ruby
# config/routes.rb
Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  resources :artists do
    resources :albums do
      resources :songs
    end
  end
  resources :albums
  resources :playlists do
    resources :songs
  end
  resources :songs
end
```

Con esto, como vimos verán las nuevas rutas que tienen disponibles con el comando `rails routes` y cada uno de los métodos asociados a ellas. Recuerden que solo se mantienen por si solas las del **primer nivel de anidación**, el resto solo existirán dentro de sus *parents*, deben agregarlas al primer nivel si las necesitan.

Ahora con estas rutas, si queremos crear por ejemplo una nueva canción en el álbum de un artista, debemos utilizar `new_artist_album_song`, que como se pueden fijar recibe el parámetro `artist_id` y `album_id` y se puede acceder desde `localhost:3000/artists/<artist_id>/albums/<album_id>/songs/new`. Entonces, ahora cuando creemos dicha canción, lo que hará será agregar el id de dicho album a la columna `album_id` de la tabla de canciones (Pero no tan rápido! Faltan más pasos).

### Disclaimer
Antes de seguir, un disclaimer: si al crear nuestras entidades inicialmente no agregamos nuestra foreign key, debemos hacerlo ahora con una migración, un ejemplo:

```bash
rails generate migration AddPlaylistIdToSongs playlist:references
```
Con esto se creará un archivo en el path `db/migrate`, y acá agregarán cualquier acción para editar la base de datos, en nuestro caso:

```ruby
# db/migrate/<numero>_add_playlist_id_to_songs.rb
class AddPlaylistIdToSongs < ActiveRecord::Migration[5.1]
  def change
    add_column :songs, :playlist_id, :integer
  end
end
```

Acá le estamos diciendo: agrégale una columna a `Song`, que por convención de ActiveRecord se llamará `playlist_id` y que referencie la columna `id` del modelo `Playlist`.

Luego de **cualquier cambio a la base de datos**, tenemos que migrarla por supuesto:

```bash
rails db:migrate
```

## 3. Editar el controlador y nuestras views
Ahora viene la parte más tediosa. Por ahora nuestros `scaffold` nos crearon *views* y funciones en nuestros controladores para prácticamente todo, sin embargo no nos son totalmente útiles por tres cosas:

1. Probablemente queremos que al entrar a cada playlist o album nos muestre las canciones que tiene, además de agregar links para efectivamente añadirlas y crearlas respectivamente.

2. El form que tenemos actualmente para crear canciones no utiliza el nuevo path que creamos.

3. El controlador para `create` no tiene idea tampoco que algo cambió.

Dividiremos lo que viene en dos partes, que si bien tienen pasos análogos, la relación entre `Playlists` y `Songs` incluye algunos distintos.

## > Albums y Songs

### Views

Para el primer caso, es simple, tenemos que editar la vista y pueden elegir en un principio hacer un link simple desde `albums/1/` a `albums/1/songs/` o renderear las canciones en el mismo `albums/1/`. Acá un ejemplo de esto último:

```erb
<!-- /app/views/playlists/show.html.erb -->
<p id="notice"><%= notice %></p>

<p>
  <strong>Title:</strong>
  <%= @album.title %>
</p>

<!-- Acá usamos el nuevo atributo artist de album para poder volver al index de los albumes de un artista, ademas de los nuevos paths que tenemos -->
<%= link_to 'Edit', edit_artist_album_path(@artist.album, @album) %> |
<%= link_to 'Back', artist_albums_path(@album.artist) %>

<h1>Songs</h1>

<table>
  <thead>
    <tr>
      <th>Title</th>
      <th>Artist</th>
      <th>Duration</th>
      <th colspan="3"></th>
    </tr>
  </thead>

  <tbody>
    <% @album.songs.each do |song| %>
    <!–– Se fijan que acá usamos nuestro nuevo atributo songs? Y en los próximos links de show y edit ocupamos las nuevas rutas también, pasando los parámetros necesarios -->
      <tr>
        <td><%= song.title %></td>
        <td><%= song.album.artist.name %></td>
        <td><%= song.duration %></td>
        <td><%= link_to 'Show', artist_album_song_path(@album.artist, @album, song) %></td>
        <td><%= link_to 'Edit', edit_artist_album_song_path(@album.artist, @album, song) %></td>
        <td><%= link_to 'Destroy', artist_album_song_path(@album.artist, @album, song), method: :delete, data: { confirm: 'Are you sure?' } %></td>
      </tr>
    <% end %>
  </tbody>
</table>

<br>

<%= link_to 'New Song', new_artist_album_song_path(@album.artist, @album, song) %>
```

 Acá hicimos uso de nuestras nuevas rutas y los parámetros que recibe cada una de ellas, tanto para crear, mostrar, editar y eliminar nuestras canciones. Por ahora tenemos **comandos disponibles** gracias a las asociaciones en el modelo, **nuevas rutas disponibles y sus respectivos métodos** gracias a las *nested routes* y **vistas actualizadas que muestran nuestras relaciones a través de estos comandos y rutas**. Sin embargo, lo que nos falta es que el controlador, que es **el intermediario entre las vistas y nuestra base de datos**, ocupe correctamente estas nuevas asociaciones.

 ### Controladores

 Es necesario ahora, que si yo creo una nueva canción dentro de un album, esta canción efectivamente guarde esta foreign key en su instancia. Cada ruta y cada vista apunta a un método dentro del controlador (por eso los alcances de nombres, esto es muy importante para que Rails haga su trabajo). En este caso, la acción que se gatilla al crear una nueva instancia es `create`.
 ```ruby
 def create
     @song = Song.new(song_params)
     @song.album = @album
     respond_to do |format|
       if @song.save
         format.html { redirect_to artist_album_path(@album), notice: 'Song was successfully created.'}
       else
         format.html { render :new }
         format.json { render json: @song.errors, status: :unprocessable_entity }
       end
     end
   end
 ```
 *(Hay que hacer lo mismo con las otras acciones pertinentes, es análogo)*

Como ven, lo que hicimos fue decirle al método que si creo una instancia nueva, voy a agregarle el `album` al que pertenece. En este caso usamos una variable, que por supuesto no hemos definido. Es acá cuando entra en juego la sentencia `before_action`. Es auto-descriptiva: lo que hace es ejecutar alguna función "antes de una acción", y recibe justamente estos parámetros.

```ruby
# /app/controllers/songs_controller.rb
class SongsController < ApplicationController
  before_action :set_song, only: [:show, :edit, :update, :destroy]
  before_action :set_album, only: [:new, :update, :create, :show]

# Acá hay código que me salté

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_song
      @song = Song.find(params[:id])
    end

    def set_album
      @album = Album.find(params[:album_id])
    end
```

Ven lo que hicimos? Le dijimos al controlador que antes de realizar las acciones `:new, :update, :create, :show`, tiene que ejecutar `set_album`. Esta función busca en el modelo `Album` el parámetro de nuestros HTTP headers llamado `album_id`. Con esto, vamos a poder utilizar esa variable `@album` en cada una de dichas acciones.

### Forms

Finalmente, tenemos que decirle también al formulario que ahora estamos enviando los parámetros ingresados por el cliente a otra ruta:

```erb
# app/views/songs/_form.html.erb
<%= form_with(url: (@song.new_record? ? [@album.artist, @album, @song] : artist_album_song_path), model: @song, local: true) do |form| %>
<% if song.errors.any? %>
  <div id="error_explanation">
    <h2><%= pluralize(song.errors.count, "error") %> prohibited this song from being saved:</h2>

    <ul>
    <% song.errors.full_messages.each do |message| %>
      <li><%= message %></li>
    <% end %>
    </ul>
  </div>
<% end %>

<div class="field">
  <%= form.label :title %>
  <%= form.text_field :title %>
</div>

<div class="actions">
  <%= form.submit %>
</div>
<% end %>
```

Y *voilà!* Ya podemos crear canciones dentro de nuestros albumes.

## > Playlists y Songs

Acá todo sigue exactamente igual. Creo una playlist, le asigno el usuario actual en el controlador al momento del create y *bam*, estamos listos. Lo que queremos lograr, en contraste con los albumes, es agregar canciones que ya existen, no crear nuevas. De esta forma, lo que vamos a hacer es crear dos métodos nuevos:

1. `song_list`, que me carga todas las canciones para luego listarlas en la vista del mismo nombre y que se gatilla al poner `Add songs to playlist` en el show de alguna lista de reproducción.
2. `add_song`, que me agrega la canción elegida a las canciones de la playlist (`playlist.songs`), no tiene vista asociada y se gatilla al hacer click en `Add song` al costado de cada una de las canciones en la vista de `song_list`

### Controlador
Crearemos primero los métodos explicados anteriormente.

```ruby
class PlaylistsController < ApplicationController
  before_action :set_playlist, only: [:show, :edit, :update, :destroy]

  # Me salté código aquí

  def song_list
  end

  def add_song
    @playlist.songs << @song
    redirect_to playlist_path(@playlist)
  end

  # Me salté código aquí
```

Como pueden ver, es bien directo. `song_list` no ejecuta ninguna instrucción especial y como dije antes, lo que queremos de `add_song` es que agregue la canción a la playlist (además de luego redirigirnos para que la podamos ver, ya que no tiene vista asociada).

Luego, recuerden que las variables que ocupamos no las he definido en ninguna parte, por lo que debo agregar:

1. `@playlist` ya está listo en el método `set_playlist`, por lo que agregamos nuestros nuevos métodso al `before_action` para que lo ejecute.

```ruby
class PlaylistsController < ApplicationController
  before_action :set_playlist, only: [:show, :edit, :update, :destroy, :song_list, :add_song]

  # Me salté código aquí

  def song_list
  end

  def add_song
    @playlist.songs << @song
    redirect_to playlist_path(@playlist)
  end

  # Me salté código aquí
```

2. `@song` es la canción que queremos agregar y viene con la request HTTP, por lo que debemos desempaquetarla. Para esto crearemos el método `find_song` y lo ejecutaremos antes de la acción `add_song`.

```ruby
class PlaylistsController < ApplicationController
  before_action :set_playlist, only: [:show, :edit, :update, :destroy, :song_list, :add_song]
  before_action :find_song, only: [:add_song]

  # Me salté código aquí

  def song_list
  end

  def add_song
    @playlist.songs << @song
    redirect_to playlist_path(@playlist)
  end

  # Me salté código aquí

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_playlist
      @playlist = Playlist.find(params[:id])
    end

    def find_song
      @song = Song.find(params[:song_id])
    end

    # Only allow a list of trusted parameters through.
    def playlist_params
      params.require(:playlist).permit(:title)
    end
end
```

3. `@songs`, esta variable es más sutil porque no la vemos usada en el controlador, pero si se fijan es necesaria para la vista de nuestro nuevo método `song_list`, donde iteraremos por sobre todas las canciones para mostrarlas y luego poder agregarlas a nuestra playlist.

```ruby
class PlaylistsController < ApplicationController
  before_action :set_playlist, only: [:show, :edit, :update, :destroy, :song_list, :add_song]
  before_action :find_song, only: [:add_song]
  before_action :load_songs, only: [:song_list]

  # Me salté código aquí

  def song_list
  end

  def add_song
    @playlist.songs << @song
    redirect_to playlist_path(@playlist)
  end

  # Me salté código aquí

  private
    # me salté código

    def load_songs
      @songs = Song.all
    end

    def find_song
      @song = Song.find(params[:song_id])
    end

    # Only allow a list of trusted parameters through.
    def playlist_params
      params.require(:playlist).permit(:title)
    end
end
```

Y estamos listos con los controladores.

### Rutas

Los nuevos métodos que creamos no tienen una ruta asociada, son solo funciones, y nosotros queremos que funcionen como *endpoints*. Es por esto que lo debemos agregar a nuestro `routes.rb`

```ruby
Rails.application.routes.draw do
  # Me salté código
  get 'playlists/:id/songs-to-add', to: 'playlists#song_list', as: :playlist_song_list
  get 'playlists/:id/add/:song_id', to: 'playlists#add_song', as: :add_playlist_song
end
```

Lo que hace esto entonces es, agrégame una nueva ruta `'playlists/:id/songs-to-add'`, la que recibirá todo lo que esté con ":" como parámetro, que apunte al método `song_list` que se encuentra en el controlador de `playlists`. Ponle a este endpoint `playlist_song_list`.
Es análogo lo que ocurre con el otro.

### Views
Ya tenemos todo lo que necesitamos para editar nuestras vistas, y esto sí es análogo al ejemplo anterior, solo deben ocupar las nuevas rutas que tenemos y las variables que ahora tenemos disponibles. Pueden verlas en el proyecto subido.


Ojalá que esta guía les sea útil! :sparkles: Como siempre, les recomendamos que busquen harto en internet, que vean más ejemplos de otros proyectos y que revisen la documentación de ActiveRecord, hay muchísimas formas distintas de hacer las cosas y muchas herramientas más que les podrían servir. Por supuesto, no duden en preguntarnos también en las issues!

Mucha suerte en el siguiente sprint!
