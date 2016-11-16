module Economy
  module Rates
    class Base

      private

      def get(uri)
        Net::HTTP.get_response uri
      end

    end
  end
end
