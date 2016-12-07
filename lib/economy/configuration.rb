module Economy
  class Configuration

    attr_accessor :redis, :rates, :default_currency

    def add_currency(*args)
      Economy.currencies.add *args
    end

  end
end
