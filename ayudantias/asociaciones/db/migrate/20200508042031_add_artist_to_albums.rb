class AddArtistToAlbums < ActiveRecord::Migration[5.2]
  def change
    add_reference :albums, :artist, foreign_key: true
  end
end
