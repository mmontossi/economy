module Economy
  class Configuration

    attr_accessor :redis, :rates, :default_currency

    def register_currency(*args)
      Economy.currencies.add *args
    end

  end
end
