class AddDescriptionToPeliculas < ActiveRecord::Migration[5.2]
  def change
    add_column :peliculas, :descripcion, :string
  end
end
