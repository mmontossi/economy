module Economy
  module Rates
    class Base

      attr_reader :retries

      def initialize
        @retries = 0
      end

      def fetch
        begin
          call
        rescue
          if retries < 30
            sleep 60
            @retries += 1
            fetch
          else
            puts "Giving up after #{retries} retries"
          end
        end
      end

    end
  end
end
