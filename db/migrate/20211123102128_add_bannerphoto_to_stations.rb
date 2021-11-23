class AddBannerphotoToStations < ActiveRecord::Migration[6.0]
  def change
    add_column :stations, :bannerphoto, :string
  end
end
