class CreateReviews < ActiveRecord::Migration[6.0]
  def change
    create_table :reviews do |t|
      t.string :visitor_pseudo
      t.integer :vibes_rating
      t.integer :ski_rating
      t.integer :value_money_rating
      t.references :station, null: false, foreign_key: true

      t.timestamps
    end
  end
end
