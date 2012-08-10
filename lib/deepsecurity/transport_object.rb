# @author Udo Schneider <Udo.Schneider@homeaddress.de>

require "deepsecurity/type_mappings"

module DeepSecurity

  # @abstract
  # Transport objects are modeled after Deep Security Manager web interface objects and configuration groups. These
  # transport objects can be constructed as new or retrieved from the Manager by calling the appropriate web method.
  #
  # A Web Service definition may declare object classes that inherit properties from other base object classes, so only
  # the relevant object classes are covered in this section. If during development, you encounter any WSDL-defined
  # object classes that are not documented, they are likely inherited base object classes or response object classes
  # that are not directly used by any Web Methods and do not have any direct value.
  # @note
  #   It defines it's own DSL to specify attributes, caching and operation. This allows you to completely hide the
  #   type-conversion needed by Savon behind a regular Ruby object.
  class TransportObject

    # The Deep Security Manager instance this instance was created by
    # @return [Manager]
    attr_accessor :dsm


    @@ivar_savon_mappings = Hash.new()
    @@cache_aspects = Hash.new()

    def ivar_savon_mappings
      self.class.ivar_savon_mappings
    end

    def cache_aspects
      self.class.cache_aspects
    end


    def cache_key(aspect)
      self.class.cache_key(aspect, self.send(aspect))
    end

    def cachable?
      !cache_aspects.empty?
    end

    def cache
      @dsm.cache
    end

    def raise_ivar_type_not_defined(ivar_name, type, value)
      message = "No type information for #{self.class}@#{ivar_name} = #{value}!"
      puts message.colorize(:red)
    end

    def raise_type_mapping_not_defined(ivar_name, type, value)
      message = "No type information for #{self.class}<#{type}>@#{ivar_name} = #{value}!"
      raise message
    end

    def value_for_ivar(ivar_name, value)
      mapping = ivar_savon_mappings[ivar_name]
      raise_ivar_type_not_defined(ivar_name, mapping, value) if mapping.nil?
      savon_value_for_ivar(mapping, ivar_name, value)
    end

    def savon_value_for_ivar(mapping, ivar_name, value)
      return value.to_s if mapping.nil?
      return nil if value.nil?
      return mapping.from_savon_data(value)
      raise "Halt"
      if mapping.class == Hash
        if mapping[:type] == :enum
          return_value = mapping[:enum][value]
          raise "Unknown enum value \"#{value}\" in #{mapping[:enum]}" if return_value.nil?
          return return_value
        end
        if mapping[:type] == :class
          object_class = mapping[:class]
          return nil if object_class.nil?
          return object_class.new(@dsm, value)
        end
        if mapping[:type] == :array
          element_type = mapping[:element_type]
          item = value[:item]
          return item.collect { |each| savon_value_for_ivar(element_type, ivar_name, each) } if item.kind_of?(Array)
          return [savon_value_for_ivar(element_type, ivar_name, item)]
        end
      end
      raise_type_mapping_not_defined(ivar_name, mapping, value)
      nil
    end

    def value_from_ivar(ivar_name, value)
      mapping = ivar_savon_mappings[ivar_name]
      raise_ivar_type_not_defined(ivar_name, mapping, value) if mapping.nil?
      savon_value_from_ivar(mapping, ivar_name, value)
    end

    def savon_value_from_ivar(mapping, ivar_name, value)
      return value.to_s if mapping.nil?
      return nil if value.nil?
      return mapping.to_savon_data(value)
      raise "Halt"
      if mapping.class == Hash
        if mapping[:type] == :enum
          return_value = mapping[:enum].key(value)
          raise "Unknown enum value \"#{value.inspect}\" in #{mapping[:enum].inspect}" if return_value.nil?
          return return_value
        end
        if mapping[:type] == :class
          raise "Implement me!"
          object_class = mapping[:class]
          return nil if object_class.nil?
          return object_class.new(@dsm, value)
        end
      end
      raise_type_mapping_not_defined(ivar_name, mapping, value)
      nil
    end

    def store_in_cache
      # puts "#{__method__}"
      cache_aspects.each { |aspect|
        # puts "Store #{self.to_s} as #{self.cache_key(aspect)}"
        cache.store(self.cache_key(aspect), self) }
    end


    def self.ivar_savon_mappings
      mappings = @@ivar_savon_mappings[self]
      return mappings if !mappings.nil?
      @@ivar_savon_mappings[self] = Hash.new()
      @@ivar_savon_mappings[self]
    end

    def self.cache_aspects
      aspect = @@cache_aspects[self]
      return aspect if !aspect.nil?
      @@cache_aspects[self] = Set.new()
      @@cache_aspects[self]
    end

    # @group DSL to define attributes mapping

    # @macro [attach] attr_boolean_accessor
    #   @!attribute [rw] $1
    #     $2
    #     @return [Boolean]
    # Define a new Boolean accessor
    def self.attr_boolean_accessor(symbol, description='')
      ivar_savon_mappings[symbol] = BooleanMapping.new(description)
      attr_accessor symbol
    end

    # @macro [attach] array_boolean_accessor
    #   @!attribute [rw] $1
    #     $2
    #     @return [Array<Boolean>]
    # Define a new Boolean Array accessor
    def self.array_boolean_accessor(symbol, description='')
      ivar_savon_mappings[symbol] = ArrayMapping.new(BooleanMapping.new, description)
      attr_accessor symbol
    end

    # @macro [attach] attr_datetime_accessor
    #   @!attribute [rw] $1
    #     $2
    #     @return [DateTime]
    # Define a new DateTime accessor
    def self.attr_datetime_accessor(symbol, description='')
      ivar_savon_mappings[symbol] = DatetimeMapping.new(description)
      attr_accessor symbol
    end

    # @macro [attach] array_datetime_accessor
    #   @!attribute [rw] $1
    #     $2
    #     @return [Array<DateTime>]
    # Define a new DateTime Array accessor
    def self.array_datetime_accessor(symbol, description='')
      ivar_savon_mappings[symbol] = ArrayMapping.new(DatetimeMapping.new, description)
      attr_accessor symbol
    end

    # @macro [attach] attr_double_accessor
    #   @!attribute [rw] $1
    #     $2
    #     @return [float]
    # Define a new Float accessor
    def self.attr_double_accessor(symbol, description='')
      ivar_savon_mappings[symbol] = FloatMapping.new(description)
      attr_accessor symbol
    end

    # @macro [attach] array_double__accessor
    #   @!attribute [rw] $1
    #     $2
    #     @return [Array<float>]
    # Define a new Float Array accessor
    def self.array_double__accessor(symbol, description='')
      ivar_savon_mappings[symbol] = ArrayMapping.new(FloatMapping.new, description)
      attr_accessor symbol
    end

    # @macro [attach] attr_enum_accessor
    #   @!attribute [rw] $1
    #     $3
    #     @return [$2]
    # Define a new Enum accessor
    def self.attr_enum_accessor(symbol, enum, description='')
      ivar_savon_mappings[symbol] = EnumMapping.new(enum, description)
      attr_accessor symbol
    end

    # @macro [attach] array_enum_accessor
    #   @!attribute [rw] $1
    #     $3
    #     @return [Array<$2>]
    # Define a new Enum Array accessor
    def self.array_enum_accessor(symbol, enum, description='')
      ivar_savon_mappings[symbol] = ArrayMapping.new(EnumMapping.new(enum), description)
      attr_accessor symbol
    end

    # @macro [attach] attr_float_accessor
    #   @!attribute [rw] $1
    #     $2
    #     @return [float]
    # Define a new Float accessor
    def self.attr_float_accessor(symbol, description='')

      ivar_savon_mappings[symbol] = FloatMapping.new(description)
      attr_accessor symbol
    end

    # @macro [attach] array_float__accessor
    #   @!attribute [rw] $1
    #     $2
    #     @return [Array<float>]
    # Define a new Float array accessor
    def self.array_float__accessor(symbol, description='')
      ivar_savon_mappings[symbol] = ArrayMapping.new(FloatMapping.new, description)
      attr_accessor symbol
    end

    # @macro [attach] attr_integer_accessor
    #   @!attribute [rw] $1
    #     $2
    #     @return [int]
    # Define a new Integer accessor
    def self.attr_integer_accessor(symbol, description='')
      ivar_savon_mappings[symbol] = IntegerMapping.new(description)
      attr_accessor symbol
    end

    # @macro [attach] array_integer_accessor
    #   @!attribute [rw] $1
    #     $2
    #     @return [Array<int>]
    # Define a new Integer Array accessor
    def self.array_integer_accessor(symbol, description='')
      ivar_savon_mappings[symbol] = ArrayMapping.new(IntegerMapping.new, description)
      attr_accessor symbol
    end

    # @macro [attach] attr_ip_address_accessor
    #   @!attribute [rw] $1
    #     $2
    #     @return [int]
    # Define a new IP Address accessor
    def self.attr_ip_address_accessor(symbol, description='')
      ivar_savon_mappings[symbol] = IPAddressMapping.new(description)
      attr_accessor symbol
    end

    # @macro [attach] array_ip_address_accessor
    #   @!attribute [rw] $1
    #     $2
    #     @return [Array<int>]
    # Define a new IP Address Array accessor
    def self.array_ip_address_accessor(symbol, description='')
      ivar_savon_mappings[symbol] = ArrayMapping.new(IPAddressMapping.new, description)
      attr_accessor symbol
    end

    # @macro [attach] attr_object_accessor
    #   @!attribute [rw] $1
    #     $3
    #     @return [$2]
    # Define a new Object accessor
    def self.attr_object_accessor(symbol, klass, description='')
      ivar_savon_mappings[symbol] = ObjectMapping.new(klass, description)
      attr_accessor symbol
    end

    # @macro [attach] array_object_accessor
    #   @!attribute [rw] $1
    #     $3
    #     @return [Array<$2>]
    # Define a new Object Array accessor
    def self.array_object_accessor(symbol, klass, description='')
      ivar_savon_mappings[symbol] = ArrayMapping.new(ObjectMapping.new(klass), description)
      attr_accessor symbol
    end

    # @macro [attach] attr_string_accessor
    #   @!attribute [rw] $1
    #     $2
    #     @return [String]
    # Define a new String accessor
    def self.attr_string_accessor(symbol, description='')
      ivar_savon_mappings[symbol] = StringMapping.new(description)
      attr_accessor symbol
    end

    # @macro [attach] array_string_accessor
    #   @!attribute [rw] $1
    #     $2
    #     @return [Array<String>]
    # Define a new String Array accessor
    def self.array_string_accessor(symbol, description='')
      ivar_savon_mappings[symbol] = ArrayMapping.new(StringMapping.new, description)
      attr_accessor symbol
    end

    # @endgroup

    def self.cache_by_aspect(*symbols)
      symbols.each { |each| cache_aspects.add(each) }
    end

    def self.cache_key(aspect, value)
      "#{self}-#{aspect}-#{value}"
    end


    # Return an initialized instance with the values from the (type-converted) hash. Store the instance in cache
    # if cacheable.
    #
    # @param dsm [Manager] The Deep Security Manager the data came from
    # @param data [Hash] A hash of simple types as provided by Savon
    # @return [TransportObject] The initialized instance.
    def self.from_savon_data(dsm, data)
      instance = self.new()
      instance.dsm = dsm
      instance.fill_from_savon_data(data)
      instance.store_in_cache if instance.cachable?
      instance
    end

    # Return the instance as a hash of simple (type-converted) values suitable for Savon.
    #
    # @return [Hash] A Hash of simple types.
    def to_savon_data
      hash = Hash.new()
      ivar_savon_mappings.keys.each do |ivar_name|
        value = value_from_ivar(ivar_name, instance_variable_get("@#{ivar_name}"))
        hash[ivar_name.to_sym] = value unless value.nil?
      end
      hash
    end

    # Set instance variables according to (type-converted) hash values
    def fill_from_savon_data(data)
      data.each do |key, value|
        instance_variable_set("@#{key}", value_for_ivar(key, value))
      end
    end

  end


end

class Object
  def to_savon_data
    self
  end
end
