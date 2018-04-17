module Economy
  module Extensions
    module ActiveRecord
      module Base
        extend ActiveSupport::Concern

        module ClassMethods

          def monetize(*args)
            builder = Builder.new(self)
            builder.define *args
          end

        end
      end
    end
  end
end
