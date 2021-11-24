class AddInseeToStations < ActiveRecord::Migration[6.0]
  def change
    add_column :stations, :insee, :string
  end
end
