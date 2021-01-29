require "test_helper"

class FoodItemsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get food_items_index_url
    assert_response :success
  end

  test "should get show" do
    get food_items_show_url
    assert_response :success
  end

  test "should get new" do
    get food_items_new_url
    assert_response :success
  end
end
