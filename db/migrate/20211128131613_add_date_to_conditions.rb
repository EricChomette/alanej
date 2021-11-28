class AddDateToConditions < ActiveRecord::Migration[6.0]
  def change
    add_column :conditions, :date, :integer
  end
end
