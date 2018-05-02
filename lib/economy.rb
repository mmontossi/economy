require 'net/http'

require 'economy/extensions/active_record/base'
require 'economy/rates/base'
require 'economy/rates/open_exchange_rates'
require 'economy/builder'
require 'economy/configuration'
require 'economy/currency'
require 'economy/exchange'
require 'economy/money'
require 'economy/railtie'
require 'economy/version'

module Economy
  class << self

    def cache
      @cache ||= Cache.new
    end

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield configuration
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
