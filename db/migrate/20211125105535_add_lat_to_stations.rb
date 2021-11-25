class AddLatToStations < ActiveRecord::Migration[6.0]
  def change
    add_column :stations, :lat, :string
  end
end
