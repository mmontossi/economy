module Economy
  class Configuration

    attr_accessor :rates, :default_currency

    def add_currency(*args)
      Economy.currencies.add *args
    end

  end
end
