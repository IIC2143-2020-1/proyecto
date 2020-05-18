Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  get 'playlists/:id/songs-to-add', to: 'playlists#song_list', as: :playlist_song_list
  get 'playlists/:id/add/:song_id', to: 'playlists#add_song', as: :add_playlist_song
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
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
