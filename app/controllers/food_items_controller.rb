class FoodItemsController < ApplicationController
require 'rubygems'
require 'excon'
before_action :authenticate_user!

    def index
     
      @search_params = params[:search] 

      res = Excon.get( "https://trackapi.nutritionix.com/v2/search/instant?query=#{@search_params}",
            headers: { "x-app-id": Rails.application.credentials.nutrition[:nutrition_id],
                        "x-app-key": Rails.application.credentials.nutrition[:nutrition_key]})
                      
      @search_items = JSON.parse(res.body)
       respond_to do |format|
           format.js {}
           format.html {}       
       end
    end
    

    
    def show
      @model = FoodItem.find(params[:id])
      
       req = Excon.post("https://trackapi.nutritionix.com/v2/natural/nutrients",
        body:  { query: "#{@model.name}"
        }.to_json,
          headers: { "x-app-id": Rails.application.credentials.nutrition[:nutrition_id],
                      "x-app-key": Rails.application.credentials.nutrition[:nutrition_key],
                      "x-remote-user-id": "0",
                      "content-type": "application/json"
                        
                      })
                       
                      req_body = JSON.parse(req.body)
                       req_body["foods"].each do |food|
                         @model.update(calories: food["nf_calories"])
                         @model.save
                       end
    end
  
    def new
    
      @model = FoodItem.new
    end
    
     def create 
         
     @model = current_user.food_items.new(name: params[:name], image: params[:image])
    if  @model.save
      redirect_to food_item_path(@model.id)
    end
     end
     
     def user_food_index
     @count = params.fetch(:count, 0).to_i
      @food_item_count = current_user.food_items.count
       @page = params.fetch(:page, 0).to_i
      
      @food_items = current_user.food_items.offset(@page).limit(1) if current_user.present?
     end
    def update
  
       @model = FoodItem.find(params[:id])
       @model.update(food_item_date_params)
       if @model.save
         redirect_to food_item_path @model.id
       end
    end
    
    private
    
    def food_item_params
      params.require(:food_item).permit(:name, :calories, :date, :image)
    end
    
    def food_item_date_params
      params.require(:food_item).permit(:date)
    end
    

end
