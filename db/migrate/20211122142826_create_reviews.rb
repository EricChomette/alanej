class CreateReviews < ActiveRecord::Migration[6.0]
  def change
    create_table :reviews do |t|
      t.string :visitor_pseudo
      t.integer :rating
      t.references :station, null: false, foreign_key: true

      t.timestamps
    end
  end
end
