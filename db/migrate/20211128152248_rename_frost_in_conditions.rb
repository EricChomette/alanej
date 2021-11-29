class RenameFrostInConditions < ActiveRecord::Migration[6.0]
  def change
    remove_column :conditions, :forst_prob, :integer
    add_column :conditions, :frost_prob, :integer
  end
end
