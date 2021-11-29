class AddSnowurlToStations < ActiveRecord::Migration[6.0]
  def change
    add_column :stations, :snowurl, :string
  end
end
