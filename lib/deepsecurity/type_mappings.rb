module DeepSecurity

  class TypeMapping

    def initialize(description=nil)
      @description = description
    end

    def from_savon_data(data)
      raise "Implement me!"
    end

    def to_savon_data(value)
      raise "Implement me!"
    end

  end

  class ArrayMapping < TypeMapping

    def initialize(element_mapping, description=nil)
      super(description)
      @element_mapping = element_mapping
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

    def initialize(enum, description=nil)
      super(description)
      @enum = enum
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

    def initialize(klass, description=nil)
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