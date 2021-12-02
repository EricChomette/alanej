class AddPlanurlToStations < ActiveRecord::Migration[6.0]
  def change
    add_column :stations, :planurl, :string
  end
end
