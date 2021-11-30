class CreateConditions < ActiveRecord::Migration[6.0]
  def change
    create_table :conditions do |t|
      t.string :snow
      t.string :weather
      t.datetime :date_on
      t.references :station, null: false, foreign_key: true

      t.timestamps
    end
  end
end
