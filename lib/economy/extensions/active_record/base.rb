module Economy
  module Extensions
    module ActiveRecord
      module Base
        extend ActiveSupport::Concern

        module ClassMethods

          def monetize(*attributes)
            builder = Builder.new(self)
            builder.define attributes
          end

        end
      end
    end
  end
end
