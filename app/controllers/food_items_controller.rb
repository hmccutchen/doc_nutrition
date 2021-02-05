class FoodItemsController < ApplicationController
require 'rubygems'
require 'excon'


    def index
      @search_params = params[:search] 

      res = Excon.get( "https://trackapi.nutritionix.com/v2/search/instant?query=#{@search_params}",
            headers: { "x-app-id": Rails.application.credentials.github["NUTRITION_ID"],
                        "x-app-key": Rails.application.credentials.github["NUTRITION_KEY"] 
                        
                      })
                      
     @search_items = JSON.parse(res.body)
      @search_items["common"].try(:each) do |nutrition_data|
        
  
          new(nutrition_data)
      end
      
      @model = FoodItem.all.where(FoodItem.arel_table[:name].lower.matches("%#{@search_params}%"))
      
    end
    

    
    def show
      @model = FoodItem.find(params[:id])
      
       req = Excon.post("https://trackapi.nutritionix.com/v2/natural/nutrients",
        body:  { query: "#{@model.name}"
        }.to_json,
          headers: { "x-app-id": Rails.application.credentials.github["NUTRITION_ID"],
                      "x-app-key": Rails.application.credentials.github["NUTRITION_KEY"],
                      "x-remote-user-id": "0",
                      "content-type": "application/json"
                        
                      })
                       
                      req_body = JSON.parse(req.body)
                       req_body["foods"].each do |food|
                         @model.update(calories: food["nf_calories"])
                         @model.save
                       end
    end
  
    def new(model_params)
      @model = FoodItem.new(name: model_params["food_name"],
                            image: model_params["photo"]["thumb"]
                            
      )
      
      if @model.save
        # redirect_to food_items_path
      end
    end
    
    def update
       @model = FoodItem.find(params[:id])
      
       @model.update(food_item_params)
       @model.save(:validate => false)
    end
    
    private
    
    def food_item_params
      params.require(:food_item).permit(:name, :calories, :date, :image)
    end
end
