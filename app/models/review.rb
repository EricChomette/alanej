class Review < ApplicationRecord
  belongs_to :station

  validates :visitor_pseudo, presence: true
  validates :vibes_rating, presence: true
  validates :ski_rating, presence: true
  validates :value_money_rating, presence: true
  validates :station, presence: true
end
