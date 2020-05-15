class AddPhotoToMovies < ActiveRecord::Migration[5.2]
  def change
    add_column :peliculas, :photo_url, :string
  end
end
