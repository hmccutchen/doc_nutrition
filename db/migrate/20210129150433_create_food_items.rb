class CreateFoodItems < ActiveRecord::Migration[6.1]
  def change
    create_table :food_items do |t|
      t.string :name
      t.string :calories
      t.datetime :date

      t.timestamps
    end
  end
end
