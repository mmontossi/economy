class Plan < ApplicationRecord

  monetize :monthly_price, :annually_price

end
