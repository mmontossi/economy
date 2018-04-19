module Economy
  class Currency < ActiveRecord::Base

    validates_presence_of :iso_code, :iso_number, :symbol, :usd_rate, :decimals
    validates_numericality_of :usd_rate, greater_than: 0
    validates_numericality_of :decimals, greater_than_or_equal_to: 0

  end
end
