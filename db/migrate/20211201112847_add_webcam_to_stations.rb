class AddWebcamToStations < ActiveRecord::Migration[6.0]
  def change
    add_column :stations, :webcamurl, :string
  end
end
