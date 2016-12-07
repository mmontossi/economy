module Economy
  class Cache

    def get(from, to)
      redis.get "exchanges/#{from.iso_code.downcase}/#{to.iso_code.downcase}"
    end

    def set(exchange)
      redis.set "exchanges/#{exchange.from.downcase}/#{exchange.to.downcase}", exchange.rate.to_s
    end

    def clear
      redis.del 'exchanges/*'
    end

    private

    def redis
      Economy.configuration.redis
    end

  end
end
