module Economy
  class Exchange < ActiveRecord::Base

    after_create :update_currency_usd_rate

    belongs_to :from, class_name: 'Currency'
    belongs_to :to, class_name: 'Currency'

    validates_presence_of :rate
    validates_numericality_of :rate, greater_than: 0

    private

    def update_currency_usd_rate
      if to.iso_code == 'USD'
        from.update usd_rate: rate
      end
    end

  end
end
