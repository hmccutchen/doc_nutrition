class FoodItem < ApplicationRecord
  validates_uniqueness_of :name, on: :create
end
