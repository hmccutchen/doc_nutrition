class AddFoodItemToUsers < ActiveRecord::Migration[6.1]
  def change
    add_reference :food_items, :users, null: false, foreign_key: true
  end
end
