# @author Udo Schneider <Udo.Schneider@homeaddress.de>

module SavonHelper

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

    def description
      @description
    end

    def object_klass
      logger.error { "#{self.class}##{__method__}() not implemented!" }
    end

    def type_string
      logger.error { "#{self.class}##{__method__}() not implemented!" }
    end

  end

  class ArrayMapping < TypeMapping

    def self.from_savon_data(klass, data)
      return [] if data.blank?
      result = []
      if data.is_a?(Array)
        data.each do |element|
          result << klass.from_savon_data(element)
        end
      elsif data.is_a?(Hash)
        item = data[:item]
        if item.nil?
          result << klass.from_savon_data(data)
        else
          result = from_savon_data(klass, item)
        end
      else
        raise "Unknown Array mapping"
      end
      result
    end

    def initialize(element_mapping, description='')
      super(description)
      @element_mapping = element_mapping
    end

    def from_savon_data(data)
      self.class.from_savon_data(@element_mapping, data)
    end

    def _from_savon_data(data)
      return @element_mapping.from_savon_data(data[:item]) if data[:item].is_a?(Hash)
      data[:item].map do |each|
        @element_mapping.from_savon_data(each)
      end
    end

    def object_klass
       @element_mapping.object_klass
    end

    def type_string
      "Array<#{@element_mapping.type_string}>"
    end

  end

  class BooleanMapping < TypeMapping

    def from_savon_data(data)
      data.to_s == "true"
    end

    def to_savon_data(value)
      value.to_s
    end

    def type_string
      "bool"
    end

  end

  class DatetimeMapping < TypeMapping

    def from_savon_data(data)
      DateTime.parse(data.to_s)
    end

    def to_savon_data(value)
      value.to_datetime.to_s
    end

    def type_string
      "datetime"
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

    def type_string
      "enum"
    end

  end

  class FloatMapping < TypeMapping

    def from_savon_data(data)
      data.to_f
    end

    def to_savon_data(value)
      value.to_s
    end

    def type_string
      "float"
    end

  end

  class IntegerMapping < TypeMapping

    def from_savon_data(data)
      Integer(data.to_s)
    end

    def to_savon_data(value)
      value.to_s
    end

    def type_string
      "int"
    end
  end

  class IPAddressMapping < TypeMapping

    def from_savon_data(data)
      data.to_s
    end

    def to_savon_data(value)
      value.to_s
    end

    def type_string
      "IPAddress"
    end

  end

  class ObjectMapping < TypeMapping

    def initialize(klass, description='')
      super(description)
      @klass = klass
    end

    def from_savon_data(data)
      @klass.from_savon_data(data)
    end

    def object_klass
      @klass
    end

    def type_string
      "#{@klass}"
    end

  end

  class StringMapping < TypeMapping

    def from_savon_data(data)
      data.to_s
    end

    def to_savon_data(value)
      value.to_s
    end

    def object_klass
      String
    end

    def type_string
      "String"
    end

  end

  class MissingMapping < TypeMapping

    def from_savon_data(data)
      data
    end

    def to_savon_data(value)
      value
    end

    def type_string
      "MISSING"
    end

  end

  class HintMapping < TypeMapping

    def initialize(klass, description='')
      super(description)
      @klass = klass
    end

    def object_klass
      @klass
    end

    def type_string
      "HINT"
    end

  end

  def self.define_missing_type_mapping(klass, ivar_name, value, mappings)
    message = "No type mapping for #{klass}@#{ivar_name} = #{value}!"
    DeepSecurity::Manager.current.logger.warn(message)
    mappings[ivar_name] = MissingMapping.new(message)
  end

end