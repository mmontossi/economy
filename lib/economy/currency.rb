module Economy
  class Currency

    attr_reader :iso_code, :iso_number

    def initialize(assignments)
      %i(iso_code iso_number symbol decimals).each do |name|
        instance_variable_set "@#{name}", assignments[name]
      end
      unless iso_code
        raise "Iso code can't be empty"
      end
    end

    def symbol
      @symbol || '$'
    end

    def decimals
      @decimals || 2
    end

    def ==(other)
      other.is_a?(Currency) && other.iso_code == iso_code
    end

  end
end
