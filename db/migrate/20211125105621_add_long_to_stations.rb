class AddLongToStations < ActiveRecord::Migration[6.0]
  def change
    add_column :stations, :long, :string
  end
end
