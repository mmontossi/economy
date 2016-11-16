class Plan < ActiveRecord::Base

  monetize :monthly_price, :annually_price

end
