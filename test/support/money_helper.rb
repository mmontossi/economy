module MoneyHelper
  extend ActiveSupport::Concern

  included do
    setup do
      Economy.cache.clear
      usd_to_uyu = Economy::Exchange.create(
        service: 'Yahoo',
        from: 'USD',
        to: 'UYU',
        rate: 20
      )
      usd_to_uyu.run_callbacks :commit
      uyu_to_usd = Economy::Exchange.create(
        service: 'Yahoo',
        from: 'UYU',
        to: 'USD',
        rate: 0.05
      )
      uyu_to_usd.run_callbacks :commit
    end
  end

  private

  def money(amount, currency)
    Economy::Money.new amount, currency
  end

end
