module Economy
  class Cache

    def rate(from, to)
      fetch "exchanges/#{from.iso_code.downcase}/#{to.iso_code.downcase}" do
        Exchange.find_by(from: from, to: to).try :rate
      end
    end

    def currency(iso_code)
      fetch "currencies/#{iso_code.downcase}" do
        Currency.find_by iso_code: iso_code
      end
    end

    private

    def expiration
      Economy.configuration.cache_expiration
    end

    def fetch(key, &block)
      Rails.cache.fetch key, expires_in: expiration, &block
    end

  end
end
