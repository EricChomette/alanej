class Review < ApplicationRecord
  AUTHORIZED_RATINGS = (1..5)

  belongs_to :station

  validates :visitor_pseudo, presence: true
  validates :rating, inclusion: { in: AUTHORIZED_RATINGS }
  validates :station, presence: true
end
