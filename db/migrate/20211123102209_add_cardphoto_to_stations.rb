class AddCardphotoToStations < ActiveRecord::Migration[6.0]
  def change
    add_column :stations, :cardphoto, :string
  end
end
