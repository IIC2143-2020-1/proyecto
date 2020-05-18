class AddAlbumToSongs < ActiveRecord::Migration[5.2]
  def change
    add_reference :songs, :album, foreign_key: true
  end
end
