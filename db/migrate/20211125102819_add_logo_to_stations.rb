class AddLogoToStations < ActiveRecord::Migration[6.0]
  def change
    add_column :stations, :logo, :string
  end
end
