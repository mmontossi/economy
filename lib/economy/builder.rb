module Economy
  class Builder

    attr_reader :model, :concern

    def initialize(model)
      @model = model
      @concern = Module.new
    end

    def define(*args)
      options = args.extract_options!
      if args.last.is_a?(Proc)
        renderer = args.pop
      end
      args.each do |attribute|
        currency_column, currency_attribute = begin
          if model.column_names.include?("#{attribute}_currency_id")
            [true, :"#{attribute}_currency"]
          elsif model.method_defined?("#{attribute}_currency")
            [false, :"#{attribute}_currency"]
          elsif model.column_names.include?('currency_id')
            [true, :currency]
          elsif model.method_defined?('currency')
            [false, :currency]
          end
        end
        if currency_column
          set_currency currency_attribute
        end
        condition_attribute = "#{attribute}_is_money?"
        define_helpers attribute, condition_attribute, options
        define_getter attribute, currency_attribute, condition_attribute, renderer
        define_setter attribute, currency_column, currency_attribute, condition_attribute
      end
      model.include concern
    end

    private

    def set_currency(currency_attribute)
      model.belongs_to currency_attribute, class_name: 'Economy::Currency'
    end

    def define_helpers(attribute, condition_attribute, options)
      concern.class_eval do
        define_method "#{attribute}_came_from_user?" do
          true
        end
        define_method "#{attribute}_before_type_cast" do
          send(attribute).to_json
        end
        target = (options[:if] || options[:unless])
        opposite = (options[:unless] ? true : false)
        define_method condition_attribute do
          if target
            value = begin
              case target
              when Symbol
                send target
              when Proc
                instance_exec &target
              end
            end
            opposite ? value.! : value
          else
            true
          end
        end
      end
    end

    def define_getter(attribute, currency_attribute, condition_attribute, renderer)
      concern.class_eval do
        define_method attribute do
          if send(condition_attribute)
            value = read_attribute(attribute)
            currency = send(currency_attribute)
            money = Economy::Money.new(
              (value || 0),
              currency,
              self,
              renderer
            )
            if enforced_currency = Economy.configuration.currency
              money.exchange_to enforced_currency
            else
              money
            end
          else
            super()
          end
        end
      end
    end

    def define_setter(attribute, currency_column, currency_attribute, condition_attribute)
      concern.class_eval do
        define_method "#{attribute}=" do |value|
          if send(condition_attribute)
            case value
            when Money
              if currency_attribute == :currency
                currency = send(currency_attribute)
                write_attribute attribute, value.exchange_to(currency).amount
              else
                write_attribute attribute, value.amount
                if currency_column
                  write_attribute currency_attribute, value.currency.iso_code
                end
              end
            else
              write_attribute attribute, value
            end
          else
            super value
          end
        end
      end
    end

  end
end
