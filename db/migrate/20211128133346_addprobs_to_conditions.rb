class AddprobsToConditions < ActiveRecord::Migration[6.0]
  def change
    add_column :conditions, :forst_prob, :integer
    add_column :conditions, :rain_prob, :integer
    add_column :conditions, :fog_prob, :integer
  end
end
