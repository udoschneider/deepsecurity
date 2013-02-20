module DeepSecurity

  class TypeMapping

    def logger
      DeepSecurity::logger
    end

    def initialize(description='')
      @description = description
    end

    def from_savon_data(data)
      logger.error { "#{self.class}##{__method__}(#{data.inspect}) not implemented!" }
    end

    def to_savon_data(value)
      logger.error { "#{self.class}##{__method__}(#{value.inspect}) not implemented!" }
    end

  end

  class ArrayMapping < TypeMapping

    def initialize(element_mapping, description='')
      super(description)
      @element_mapping = element_mapping
    end

    def from_savon_data(data)
      data[:item].map do |each|
        @element_mapping.from_savon_data(each)
      end
    end

  end

  class BooleanMapping < TypeMapping

    def from_savon_data(data)
      data.to_s == "true"
    end

    def to_savon_data(value)
      value.to_s
    end

  end

  class DatetimeMapping < TypeMapping

    def from_savon_data(data)
      DateTime.parse(data.to_s)
    end

    def to_savon_data(value)
      value.to_datetime.to_s
    end

  end

  class EnumMapping < TypeMapping

    def initialize(enum, description='')
      super(description)
      @enum = enum
    end

    def from_savon_data(data)
      @enum[data]
    end

    def to_savon_data(value)
      @enum.key(value)
    end

  end

  class FloatMapping < TypeMapping

    def from_savon_data(data)
      data.to_f
    end

    def to_savon_data(value)
      value.to_s
    end

  end

  class IntegerMapping < TypeMapping

    def from_savon_data(data)
      data.to_i
    end

    def to_savon_data(value)
      value.to_s
    end

  end

  class IPAddressMapping < TypeMapping

    def from_savon_data(data)
      data.to_s
    end

    def to_savon_data(value)
      value.to_s
    end

  end

  class ObjectMapping < TypeMapping

    def initialize(klass, description='')
      super(description)
      @klass = klass
    end

  end

  class StringMapping < TypeMapping

    def from_savon_data(data)
      data.to_s
    end

    def to_savon_data(value)
      value.to_s
    end

  end

end