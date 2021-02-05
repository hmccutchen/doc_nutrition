class FoodItemsController < ApplicationController
require 'rubygems'
require 'excon'


    def index
      @search_params = params[:search] 

      res = Excon.get( "https://trackapi.nutritionix.com/v2/search/instant?query=#{@search_params}",
            headers: { "x-app-id": "17525051",
                        "x-app-key": "5fb4c948fda915dd4d11ac6b799e6821" 
                        
                      })
                      
      @search_items = JSON.parse(res.body)
    #   @search_items["common"].try(:each) do |nutrition_data|
        
    # nutrition_data
    #       # new(nutrition_data)
    #   end
      
      # @model = FoodItem.all.where(FoodItem.arel_table[:name].lower.matches("%#{@search_params}%"))
      
    end
    

    
    def show
      @model = FoodItem.find(params[:id])
      
       req = Excon.post("https://trackapi.nutritionix.com/v2/natural/nutrients",
        body:  { query: "#{@model.name}"
        }.to_json,
          headers: { "x-app-id": "17525051",
                      "x-app-key": "5fb4c948fda915dd4d11ac6b799e6821",
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
       
     @model = FoodItem.new(name: params[:name], image: params[:image])
    if  @model.save!
      redirect_to food_item_path(@model.id)
    end
     end
    def update
       @model = FoodItem.find(params[:id])
      puts @model.inspect
      puts params.inspect
       @model.update(food_item_date_params)
       @model.save!
    end
    
    private
    
    def food_item_params
      params.require(:food_item).permit(:name, :calories, :date, :image)
    end
    
    def food_item_date_params
      params.require(:food_item).permit(:date)
    end
end
