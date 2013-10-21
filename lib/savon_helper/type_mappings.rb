# @author Udo Schneider <Udo.Schneider@homeaddress.de>

module SavonHelper

  # A TypeMapping class is responsible for converting between Savon primitive types and Ruby Types
  class TypeMapping

    # A new instance of TypeMapping with description
    # @param description [String] A String describing the mapping.
    # @return [TypeMapping]
    def initialize(name='', description='')
      @name = name
      @description = description
    end

    # @!group Converting

    # @abstract Convert from Savon data to Ruby value
    # @param data [Hash, Object] Source Savon data
    # @return [Object]
    def to_native(data)
      raise "#{self.class}##{__method__}(#{data.inspect}) not implemented!"
    end

    # @abstract Convert from Ruby value type to Savon data
    # @param value [Object] Source Ruby value
    # @return [Object]
    def to_savon(value)
      raise "#{self.class}##{__method__}(#{value.inspect}) not implemented!"
    end

    # @!endgroup

    # Return the description
    # @return [String]
    def description
      @description
    end

    # @abstract Return the class represented by the mapping.
    # @return [Class]
    def object_klass
      raise "#{self.class}##{__method__}() not implemented!"
    end

    # @abstract Return the class description represented by the mapping.
    # @return [String]
    def type_string
      raise "#{self.class}##{__method__}() not implemented!"
    end

    # @abstract Return the default value the mapping.
    # @return [Object]
    def default_value
      raise "#{self.class}##{__method__}() not implemented!"
    end

    # Warn about unparsable mapping
    # @todo Check if mappings can be derived from klass
    # @param data [Hash, Object] Source Savon data
    def warn_unparseable_data(data, interface)
      message = "Can't parse #{type_string} #{@name.inspect}: #{data.inspect}"
      interface.logger.warn(message)
      self.default_value()
    end

  end

  # BooleanMapping maps Savon data to Ruby Booleans.
  class BooleanMapping < TypeMapping

    # @!group Converting

    # Convert from Savon data to Ruby Boolean
    # @param data [Hash, Boolean, String] Source Savon data
    # @return [Boolean]
    def to_native(data, interface)
      data.to_s == "true"
    end

    # Convert from Ruby Boolean type to Savon data
    # @param value [Boolean] Source Ruby data
    # @return [String]
    def to_savon(value)
      value.to_s
    end

    # @!endgroup


    # Return the class represented by the mapping.
    # @return [TrueClass] Return TrueClass as Ruby as no common Boolan class
    def object_klass
      TrueClass
    end

    # Return the class description represented by the mapping.
    # @return [String]
    def type_string
      "bool"
    end

    # @abstract Return the default value the mapping.
    # @return [Object]
    def default_value
      false
    end

  end

  # IntegerMapping maps Savon data to Ruby integers.
  class IntegerMapping < TypeMapping

    # @!group Converting

    # Convert from Savon data to Ruby integers
    # @param data [Hash, String] Source Savon data
    # @return [Integer]
    def to_native(data, interface)
      Integer(data.to_s)
    end

    # Convert from Ruby float type to Savon data
    # @param value [Integer] Source Ruby data
    # @return [String]
    def to_savon(value)
      value.to_s
    end

    # @!endgroup

    # Return the class represented by the mapping.
    # @return [Integer]
    def object_klass
      Integer
    end

    # Return the class description represented by the mapping.
    # @return [String]
    def type_string
      "int"
    end

    # @abstract Return the default value the mapping.
    # @return [Object]
    def default_value
      0
    end

  end

  # FloatMapping maps Savon data to Ruby floats.
  class FloatMapping < TypeMapping

    # @!group Converting

    # Convert from Savon data to Ruby floats
    # @param data [Hash, String] Source Savon data
    # @return [Float]
    def to_native(data)
      data.to_f
    end

    # Convert from Ruby float type to Savon data
    # @param value [Float] Source Ruby data
    # @return [String]
    def to_savon(value)
      value.to_s
    end

    # @!endgroup

    # Return the class represented by the mapping.
    # @return [Float]
    def object_klass
      Float
    end

    # Return the class description represented by the mapping.
    # @return [String]
    def type_string
      "float"
    end

    # @abstract Return the default value the mapping.
    # @return [Object]
    def default_value
      0.0
    end

  end

  # StringMapping maps Savon data to Ruby strings.
  class StringMapping < TypeMapping

    # @!group Converting

    # Convert from Savon data to Ruby strings
    # @param data [Hash, String] Source Savon data
    # @return [String]
    def to_native(data, interface)
      data.to_s
    end

    # Convert from Ruby string type to Savon data
    # @param value [String] Source Ruby data
    # @return [String]
    def to_savon(value)
      value.to_s
    end

    # @!endgroup

    # @abstract Return the class represented by the mapping.
    # @todo Is this really neccessary?
    # @return [Class]
    def object_klass
      String
    end

    # Return the class description represented by the mapping.
    # @return [String]
    def type_string
      "String"
    end

    # @abstract Return the default value the mapping.
    # @return [Object]
    def default_value
      ""
    end

  end

  # IPAddressMapping maps Savon data to Ruby IP Address String.
  # @note Currently IPAddressMapping only does a from/to String mapping. The IP Address is not parsed in any way!
  class IPAddressMapping < StringMapping

    # Return the class description represented by the mapping.
    # @return [String]
    def type_string
      "IPAddress"
    end

    # @abstract Return the default value the mapping.
    # @return [Object]
    def default_value
      "255.255.255.255"
    end

  end

  # DatetimeMapping maps Savon data to Ruby DateTimes.
  class DatetimeMapping < TypeMapping

    # @!group Converting

    # Convert from Savon data to Ruby datetime
    # @param data [Hash, String] Source Savon data
    # @return [DateTime]
    def to_native(data, interface)
      DateTime.parse(data.to_s)
    end

    # Convert from Ruby DateTime type to Savon data
    # @param value [DateTime] Source Ruby data
    # @return [String]
    def to_savon(value)
      value.to_datetime.to_s
    end

    # @!endgroup

    # Return the class represented by the mapping.
    # @return [DateTime]
    def object_klass
      DateTime
    end

    # Return the class description represented by the mapping.
    # @return [String]
    def type_string
      "datetime"
    end

    # @abstract Return the default value the mapping.
    # @return [Object]
    def default_value
      DateTime.now()
    end

  end

  # EnumMapping maps Savon integers to Ruby symbols.
  class EnumMapping < TypeMapping

    # A new instance of EnumMapping with description and enum hash enum.
    # @param enum [Hash{String => Symbol}] Mapping between Savon Strings and Ruby Symbols.
    # @param description [String]
    # @return [EnumMapping]
    def initialize(enum, name='', description='')
      super(name, description)
      @enum = enum
    end

    # @!group Converting

    # Convert from Savon enum-String to Ruby Symbol
    # @param data [String] Source Savon data
    # @return [Symbol, nil]
    def to_native(data, interface)
      @enum[data]
    end

    # Convert from Ruby DateTime Symbol to  Savon enum-String
    # @param value [Symbol] Source Ruby data
    # @return [String]
    def to_savon(value)
      @enum.key(value)
    end

    # @!endgroup

    # Return the class description represented by the mapping.
    # @return [String]
    def type_string
      "enum<#{@enum.values.join(', ')}>"
    end

    # @abstract Return the default value the mapping.
    # @return [Object]
    def default_value
      :none
    end

  end

  # HintMapping maps Savon data to Ruby objects of type klass (r/o).
  class HintMapping < TypeMapping

    # A new instance of ObjectMapping with description for class klass.
    # @param klass [Class] A class returned by the hint accessor
    # @param description [String]
    # @return [HintMapping]
    def initialize(klass, name='', description='')
      super(name, description)
      @klass = klass
    end

    # @!endgroup

    # @abstract Return the class represented by the mapping.
    # @return [Class]
    def object_klass
      @klass
    end

    # Return the class description represented by the mapping.
    # @return [String]
    def type_string
      "HINT<#{@klass.name_without_namespace}>"
    end

  end

  # ObjectMapping maps Savon data to Ruby Objects.
  class ObjectMapping < HintMapping

    # Convert from Savon data to Ruby Object.
    # @param data [Hash, String] Source Savon data
    # @param klass [Class, #to_native] A class which can create instances from Savon data and provide Savon data for export.
    # @return [SavonHelper::MappingObject, #to_native]
    def self.to_native(klass, data, interface)
      klass.from_savon(data, interface)
    end

    # A new instance of ObjectMapping with description for class klass.
    # @param klass [Class, #to_native] A class which can create instances from Savon data and provide Savon data for export.
    # @param description [String]
    # @return [ObjectMapping]
    def initialize(klass, name='', description='')
      super(klass, name, description)
    end

    # @!group Converting

    # Convert from Savon data to Ruby Object.
    # @param data [Hash, String] Source Savon data
    # @return [SavonHelper::MappingObject, #to_native]
    def to_native(data, interface)
      self.class.to_native(@klass, data, interface)
    end

    # @!endgroup

  end

  # ArrayMapping maps Savon data to Ruby Arrays
  class ArrayMapping < TypeMapping

    # Convert the given Savon data to an Array consisting of elements described by element_mapping
    # @param element_mapping [TypeMapping] TypeMapping for elements
    # @param data [Hash,Array] Source Savon Data
    # @return [Array<element_mapping>]
    def self.to_native(element_mapping, data, interface)
      return [] if data.blank?
      result = []
      if data.is_a?(Array)
        data.each do |element|
          result << element_mapping.to_native(element, interface)
        end
      elsif data.is_a?(Hash)
        item = data[:item]
        if item.nil?
          result << element_mapping.to_native(data, interface)
        else
          result = to_native(element_mapping, item, interface)
        end
      else
        result = warn_unparseable_data(data, interface)
      end
      result
    end

    # A new instance of TypeMapping with description
    # @param element_mapping [TypeMapping]  A TypeMapping for elements
    # @param description [String]
    # @return [ArrayMapping]
    def initialize(element_mapping, name='', description='')
      super(name, description)
      @element_mapping = element_mapping
    end

    # @!group Converting

    # Convert from Savon data to Ruby value
    # @param data [Hash, Hash] Source Savon data
    # @return [Array<@element_mapping>]
    def to_native(data, interface)
      self.class.to_native(@element_mapping, data, interface)
    end

    # @!endgroup

    # Return the class represented by the mapping.
    # @return [Class]
    def object_klass
      @element_mapping.object_klass
    end

    # Return the class description represented by the mapping.
    # @return [String]
    def type_string
      "Array<#{@element_mapping.type_string}>"
    end

    # @abstract Return the default value the mapping.
    # @return [Object]
    def default_value
      []
    end

  end

  # MissingMapping maps Savon data to itself (no conversion).
  class MissingMapping < TypeMapping

    # @!group Converting

    # Convert from Savon data to itself.
    # @param data [Object] Source Savon data
    # @return [Object]
    def to_native(data, interface)
      data
    end

    # Convert from itself (no conversion) to Savon data.
    # @param value [Object] Source Ruby data
    # @return [Object]
    def to_savon(value)
      value
    end

    # @!endgroup

    # Return the class description represented by the mapping.
    # @return [String]
    def type_string
      "UNDEFINED"
    end

  end

  # Define a MissingMapping for the given options
  # @todo Check if mappings can be derived from klass
  # @param klass [Class] The class to define the mapping for.
  # @param ivar_name [Symbol] The name of the ivar/accessor to hold/access the value
  # @param value [Object] The value to set the ivar to.
  # @param mappings [Hash{Symbol=>TypeMapping}] The mappings hash to add the HintMapping to.
  def self.define_missing_type_mapping(klass, ivar_name, value, mappings, interface)
    message = "No type mapping for #{klass}@#{ivar_name} = #{value}!"
    interface.logger.warn(message)
    mappings[ivar_name] = MissingMapping.new(message)
  end

end