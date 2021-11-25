class CreateStations < ActiveRecord::Migration[6.0]
  def change
    create_table :stations do |t|
      t.string :name
      t.string :address
      t.text :description
      t.string :budget
      t.integer :alt_min
      t.integer :alt_max
      t.integer :total_slopes
      t.integer :open_slopes
      t.integer :green_slopes
      t.integer :green_open_slopes
      t.integer :blue_slopes
      t.integer :blue_open_slopes
      t.integer :red_slopes
      t.integer :red_open_slopes
      t.integer :black_slopes
      t.integer :black_open_slopes

      t.timestamps
    end
  end
end
