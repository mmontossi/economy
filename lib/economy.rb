require 'economy/extensions/active_record/base'
require 'economy/rates/base'
require 'economy/rates/yahoo'
require 'economy/builder'
require 'economy/cache'
require 'economy/configuration'
require 'economy/currencies'
require 'economy/currency'
require 'economy/money'
require 'economy/railtie'
require 'economy/version'

module Economy
  class << self

    def cache
      @cache ||= Cache.new
    end

    def currencies
      @currencies ||= Currencies.new
    end

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield configuration
    end

    def rate(*args)
      cache.send :fetch, *args
    end

    def update_rates
      class_name = configuration.rates.to_s.classify
      rates = Rates.const_get(class_name).new
      rates.fetch.each do |from, to, rate|
        puts "Updating exchange #{from} => #{to} with rate #{rate}"
        Exchange.create service: class_name, from: from, to: to, rate: rate
      end
    end

  end
end
