 class MacrosController < ApplicationController 
 def display
    render({ :template => "macro/new_form" })
  end
end
