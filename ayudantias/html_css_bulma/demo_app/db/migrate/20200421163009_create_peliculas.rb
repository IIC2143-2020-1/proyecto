class CreatePeliculas < ActiveRecord::Migration[5.2]
  def change
    create_table :peliculas do |t|
      t.string :titulo
      t.integer :ano
      t.string :director

      t.timestamps
    end
  end
end
