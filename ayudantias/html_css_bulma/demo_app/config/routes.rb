Rails.application.routes.draw do
  
  # Estos dos son equivalentes
  get '/', to: 'pages#main'
  root to: 'pages#main'

  get 'info', to: 'pages#info'


  # Rutas del CRUD
  
  # Create
  get 'peliculas/new', to: 'peliculas#new'
  post 'peliculas', to: 'peliculas#create'

  # Read
  get 'peliculas', to: 'peliculas#index'
  get 'peliculas/:id', to: 'peliculas#show', as: :pelicula

  # Update
  get 'peliculas/:id/edit', to: 'peliculas#edit', as: :peliculas_edit
  patch 'peliculas/:id/', to: 'peliculas#update'
  put 'peliculas/:id/', to: 'peliculas#update'

  # Delete
  delete 'peliculas/:id', to: 'peliculas#destroy'

end
