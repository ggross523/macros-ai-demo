 class MacrosController < ApplicationController 
 def display
    render({ :template => "macros/new_form" })
  end

  def do_magic
    @the_description = params.fetch("description_param")
     @the_image = params.fetch("image_param")
 
     @the_image_converted = DataURI.convert(@the_image)

     c = OpenAI::Chat.new
     c.system("You are an expert nutritionist. Estimate the macronutrients (carbohydrates, protein, and fat) in grams, as well as total calories in kcal.")
     c.user(@the_description, image: @the_image)

     c.schema = '{
       "name": "nutrition_info",
       "schema": {
         "type": "object",
         "properties": {
           "carbohydrates": {
             "type": "integer",
             "description": "Amount of carbohydrates in grams."
           },
           "protein": {
             "type": "integer",
             "description": "Amount of protein in grams."
           },
           "fat": {
             "type": "integer",
             "description": "Amount of fat in grams."
           },
           "total_calories": {
             "type": "integer",
             "description": "Total calories in kilocalories."
           }
         },
         "required": [
           "carbohydrates",
           "protein",
           "fat",
           "total_calories"
         ],
         "additionalProperties": false
       },
       "strict": true
     }'
 
     @result = c.assistant!
    
    render({ :template => "macros/results" })
  end
end
