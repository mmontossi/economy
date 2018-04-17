module Economy
  class Builder

    attr_reader :model, :concern

    def initialize(model)
      @model = model
      @concern = Module.new
    end

    def define(*args)
      if args.last.is_a?(Proc)
        renderer = args.pop
      end
      args.each do |attribute|
        if model.column_names.include?("#{attribute}_currency")
          currency_attribute = :"#{attribute}_currency"
        else
          currency_attribute = :currency
        end
        set_validators attribute, currency_attribute
        define_helpers attribute
        default_currency = Economy.configuration.default_currency
        define_getter attribute, currency_attribute, default_currency, renderer
        define_setter attribute, currency_attribute, default_currency
      end
      model.include concern
    end

    private

    def set_validators(attribute, currency_attribute)
      model.validates_presence_of currency_attribute, if: -> {
        value = read_attribute(attribute)
        value && value > 0
      }
      model.validates_length_of currency_attribute, is: 3, allow_blank: true
    end

    def define_helpers(attribute)
      concern.class_eval do
        define_method "#{attribute}_came_from_user?" do
          true
        end
        define_method "#{attribute}_before_type_cast" do
          send(attribute).to_json
        end
      end
    end

    def define_getter(attribute, currency_attribute, default_currency, renderer)
      concern.class_eval do
        define_method attribute do
          value = read_attribute(attribute)
          currency = send(currency_attribute)
          Economy::Money.new(
            self,
            (value || 0),
            (currency || default_currency),
            renderer
          )
        end
      end
    end

    def define_setter(attribute, currency_attribute, default_currency)
      concern.class_eval do
        define_method "#{attribute}=" do |value|
          case value
          when Money
            if currency_attribute == :currency
              currency = (send(currency_attribute) || default_currency)
              write_attribute attribute, value.exchange_to(currency).amount
            else
              write_attribute attribute, value.amount
              write_attribute currency_attribute, value.currency.iso_code
            end
          else
            write_attribute attribute, value
          end
        end
      end
    end

  end
end
