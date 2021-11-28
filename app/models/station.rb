class Station < ApplicationRecord
  has_many :reviews, dependent: :destroy
  has_many :conditions, dependent: :destroy
end
