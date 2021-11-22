class Station < ApplicationRecord
  has_many :reviews
  has_many :conditions
end
