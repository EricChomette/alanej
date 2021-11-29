class RemoveDateFromConditions < ActiveRecord::Migration[6.0]
  def change
    remove_column :conditions, :date_on, :date
  end
end
