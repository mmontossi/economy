module Economy
  module Rates
    class OpenExchangeRates < Base

      private

      def call
        ids = Economy.currencies.map(&:iso_code).permutation(2).map(&:join).join(',')
        uri = URI('https://query.yahooapis.com/v1/public/yql')
        uri.query = URI.encode_www_form(
          q: "select * from yahoo.finance.xchange where pair in ('#{ids}')",
          env: 'store://datatables.org/alltableswithkeys',
          format: 'json'
        )
        response = Net::HTTP.get_response(uri)
        if response.code == '200'
          body = JSON.parse(response.body.downcase, symbolize_names: true)
          results = body[:query][:results][:rate]
          if results.is_a?(Hash)
            results = [results]
          end
          rates = []
          results.each do |result|
            if result[:name] != 'n/a'
              from, to = result[:name].split('/').map(&:upcase)
              rate = BigDecimal(result[:rate])
              rates << [from, to, rate]
            end
          end
          rates
        else
          []
        end
      end

    end
  end
end
