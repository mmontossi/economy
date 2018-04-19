module Economy
  class Money
    include Comparable

    attr_reader :record, :amount, :currency, :renderer

    delegate :to_d, :to_i, :to_f, to: :amount

    def initialize(record, amount, currency, renderer=nil)
      @record = record
      if amount.is_a?(BigDecimal)
        @amount = amount
      else
        @amount = BigDecimal(amount.to_s)
      end
      @currency = normalize_currency(currency)
      @renderer = renderer
    end

    def coerce(other)
      [self, other]
    end

    def abs
      build amount.abs, currency
    end
    alias_method :magnitude, :abs

    def -@
      build -amount, currency
    end

    def positive?
      amount > 0
    end

    def negative?
      amount < 0
    end

    def zero?
      amount == 0
    end

    def nonzero?
      amount != 0
    end

    def ===(other)
      if other.is_a?(Money)
        amount == other.amount && currency == other.currency
      else
        raise "Can't compare #{other.class.name} with Money"
      end
    end

    def <=>(other)
      if other.is_a?(Numeric) && other == 0
        amount <=> other
      elsif other.is_a?(Money)
        other = other.exchange_to(currency)
        amount <=> other.amount
      else
        raise "Can't compare #{other.class.name} with Money"
      end
    end

    def +(other)
      if other.is_a?(Money)
        other = other.exchange_to(currency)
        build (amount + other.amount), currency
      else
        raise "Can't add #{other.class.name} to Money"
      end
    end

    def -(other)
      if other.is_a?(Money)
        other = other.exchange_to(currency)
        build (amount - other.amount), currency
      else
        raise "Can't subtract #{other.class.name} from Money"
      end
    end

    def *(value)
      case value
      when Money
        amount * value.exchange_to(currency).amount
      when Numeric
        build (amount * value), currency
      else
        raise "Can't multiply Money by #{value.class.name}"
      end
    end

    def /(value)
      case value
      when Money
        amount / value.exchange_to(currency).amount
      when Numeric
        build (amount / value), currency
      else
        raise "Can't divide Money by #{value.class.name}"
      end
    end
    alias_method :div, :/

    def divmod(value)
      case value
      when Money
        quotient, modulo = amount.divmod(value.exchange_to(currency).amount)
        [quotient, build(modulo, currency)]
      when Numeric
        quotient, modulo = amount.divmod(value)
        [build(quotient, currency), build(modulo, currency)]
      else
        raise "Can't divide Money by #{value.class.name}"
      end
    end

    def %(value)
      divmod(value)[1]
    end
    alias_method :modulo, :%

    def remainder(value)
      case value
      when Money
        build amount.remainder(value.exchange_to(currency).amount), currency
      when Numeric
        build amount.remainder(value), currency
      else
        raise "Can't divide Money by #{value.class.name}"
      end
    end

    def exchange_to(new_currency)
      new_currency = normalize_currency(new_currency)
      if currency != new_currency
        if rate = Economy.cache.rate(currency, new_currency)
          build (amount * BigDecimal(rate)), new_currency
        else
          raise "Rate #{currency.iso_code} => #{new_currency.iso_code} not found"
        end
      else
        self
      end
    end

    def to_json(options={})
      "%.#{currency.decimals}f" % amount
    end
    alias_method :as_json, :to_json

    def to_s(precision=nil)
      value = ActiveSupport::NumberHelper.number_to_currency(
        amount,
        unit: currency.symbol,
        precision: (precision || currency.decimals)
      )
      if renderer
        record.instance_exec value, &renderer
      else
        value
      end
    end

    private

    def normalize_currency(value)
      if value.is_a?(Currency)
        value
      else
        Economy.cache.currency value
      end
    end

    def build(amount, currency)
      Money.new record, amount, currency, renderer
    end

  end
end
