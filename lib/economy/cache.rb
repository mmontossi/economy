module Economy
  class Cache

    def fetch(from, to)
      get "exchanges/#{from.iso_code.downcase}/#{to.iso_code.downcase}"
    end

    def update(exchange)
      set "exchanges/#{exchange.from.downcase}/#{exchange.to.downcase}", exchange.rate.to_s
    end

    def clear
      del 'exchanges/*'
    end

    def method_missing(name, *args, &block)
      redis.public_send name, *args, &block
    end

    private

    def redis
      @redis ||= begin
        require 'redis'
        Redis.new YAML.load_file("#{Rails.root}/config/redis.yml")[Rails.env]
      end
    end

  end
end
