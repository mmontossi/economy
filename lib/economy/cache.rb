module Economy
  class Cache

    def get(from, to)
      client.get "exchanges/#{from.iso_code.downcase}/#{to.iso_code.downcase}"
    end

    def set(exchange)
      client.set "exchanges/#{exchange.from.downcase}/#{exchange.to.downcase}", exchange.rate.to_s
    end

    def clear
      client.del 'exchanges/*'
    end

    private

    def client
      @client ||= begin
        require 'redis'
        Redis.new url: Rails.configuration.redis_url
      end
    end

  end
end
