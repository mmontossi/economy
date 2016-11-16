module Economy
  class Currencies

    def exist?(id)
      registry.has_key? id
    end

    def find(id)
      if exist?(id)
        registry[id]
      else
        raise "Currency #{id} not found"
      end
    end

    def add(*args)
      currency = Currency.new(*args)
      registry[currency.iso_code] = currency
    end

    %i(each map).each do |name|
      define_method name do |*args, &block|
        registry.values.send name, *args, &block
      end
    end

    private

    def registry
      @registry ||= {}
    end

  end
end
