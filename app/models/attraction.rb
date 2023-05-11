class Attraction < ApplicationRecord
  has_many :reviews
  has_many :users, through: :reviews

  has_many :attraction_categories
end
