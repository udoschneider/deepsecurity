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
  #
  # @note
  #   It defines it's own DSL to specify attributes, caching and operation. This allows you to completely hide the
  #   type-conversion needed by Savon behind a regular Ruby object.
  class TransportObject

    # The Deep Security Manager instance this instance was created by
    # @return [Manager]
    attr_accessor :dsm

    @@mappings = Hash.new()
    @@cache_aspects = Hash.new()

    def logger
      DeepSecurity::logger
    end

    # @group Caching

    def self.cache_aspects
      aspect = @@cache_aspects[self]
      return aspect if !aspect.nil?
      @@cache_aspects[self] = Set.new()
      @@cache_aspects[self]
    end

    def self.cache_by_aspect(*symbols)
      symbols.each { |each| cache_aspects.add(each) }
    end

    def self.cache_key(aspect, value)
      "#{self}-#{aspect}-#{value}"
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

    def store_in_cache
      cache_aspects.each { |aspect| cache.store(self.cache_key(aspect), self) }
    end

    # @group Mapping

    # Return an initialized instance with the values from the (type-converted) hash. Store the instance in cache
    # if cacheable.
    # @see #store_in_cache
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
      mappings.keys.each do |ivar_name|
        value = ivar_to_savon_data(ivar_name, instance_variable_get("@#{ivar_name}"))
        hash[ivar_name.to_sym] = value unless value.nil?
      end
      hash
    end

    # Set instance variables according to (type-converted) hash values
    # @param data [Hash] A hash of simple types as provided by Savon
    # @return [self]
    def fill_from_savon_data(data)
      data.each do |key, value|
        instance_variable_set("@#{key}", ivar_from_savon_data(key, value))
      end
    end

    def mappings
      self.class.mappings
    end

    def self.mappings
      mappings = @@mappings[self]
      return mappings if !mappings.nil?
      @@mappings[self] = Hash.new()
      @@mappings[self]
    end

    # @raise [MissingTypeMappingException] if no mapping for ivar_name can be found
    def ivar_from_savon_data(ivar_name, value)
      mapping = mappings[ivar_name]
      raise MissingTypeMappingException.origin(self.class, ivar_name, value) if mapping.nil?
      return nil if value.nil?
      mapping.from_savon_data(value)
    end

    def ivar_to_savon_data(ivar_name, value)
      mapping = mappings[ivar_name]
      raise MissingTypeMappingException.origin(self.class, ivar_name, value) if mapping.nil?
      return nil if value.nil?
      return mapping.to_savon_data(value)
    end

    # @group DSL to define attributes mapping

    # @macro [attach] attr_boolean_accessor
    #   @!attribute [rw] $1
    #     $2
    #     @return [Boolean]
    # Define a new Boolean accessor
    def self.attr_boolean_accessor(symbol, description='')
      mappings[symbol] = BooleanMapping.new(description)
      attr_accessor symbol
    end

    # @macro [attach] array_boolean_accessor
    #   @!attribute [rw] $1
    #     $2
    #     @return [Array<Boolean>]
    # Define a new Boolean Array accessor
    def self.array_boolean_accessor(symbol, description='')
      mappings[symbol] = ArrayMapping.new(BooleanMapping.new, description)
      attr_accessor symbol
    end

    # @macro [attach] attr_datetime_accessor
    #   @!attribute [rw] $1
    #     $2
    #     @return [DateTime]
    # Define a new DateTime accessor
    def self.attr_datetime_accessor(symbol, description='')
      mappings[symbol] = DatetimeMapping.new(description)
      attr_accessor symbol
    end

    # @macro [attach] array_datetime_accessor
    #   @!attribute [rw] $1
    #     $2
    #     @return [Array<DateTime>]
    # Define a new DateTime Array accessor
    def self.array_datetime_accessor(symbol, description='')
      mappings[symbol] = ArrayMapping.new(DatetimeMapping.new, description)
      attr_accessor symbol
    end

    # @macro [attach] attr_double_accessor
    #   @!attribute [rw] $1
    #     $2
    #     @return [float]
    # Define a new Float accessor
    def self.attr_double_accessor(symbol, description='')
      mappings[symbol] = FloatMapping.new(description)
      attr_accessor symbol
    end

    # @macro [attach] array_double__accessor
    #   @!attribute [rw] $1
    #     $2
    #     @return [Array<float>]
    # Define a new Float Array accessor
    def self.array_double__accessor(symbol, description='')
      mappings[symbol] = ArrayMapping.new(FloatMapping.new, description)
      attr_accessor symbol
    end

    # @macro [attach] attr_enum_accessor
    #   @!attribute [rw] $1
    #     $3
    #     @return [$2]
    # Define a new Enum accessor
    def self.attr_enum_accessor(symbol, enum, description='')
      mappings[symbol] = EnumMapping.new(enum, description)
      attr_accessor symbol
    end

    # @macro [attach] array_enum_accessor
    #   @!attribute [rw] $1
    #     $3
    #     @return [Array<$2>]
    # Define a new Enum Array accessor
    def self.array_enum_accessor(symbol, enum, description='')
      mappings[symbol] = ArrayMapping.new(EnumMapping.new(enum), description)
      attr_accessor symbol
    end

    # @macro [attach] attr_float_accessor
    #   @!attribute [rw] $1
    #     $2
    #     @return [float]
    # Define a new Float accessor
    def self.attr_float_accessor(symbol, description='')

      mappings[symbol] = FloatMapping.new(description)
      attr_accessor symbol
    end

    # @macro [attach] array_float__accessor
    #   @!attribute [rw] $1
    #     $2
    #     @return [Array<float>]
    # Define a new Float array accessor
    def self.array_float__accessor(symbol, description='')
      mappings[symbol] = ArrayMapping.new(FloatMapping.new, description)
      attr_accessor symbol
    end

    # @macro [attach] attr_integer_accessor
    #   @!attribute [rw] $1
    #     $2
    #     @return [int]
    # Define a new Integer accessor
    def self.attr_integer_accessor(symbol, description='')
      mappings[symbol] = IntegerMapping.new(description)
      attr_accessor symbol
    end

    # @macro [attach] array_integer_accessor
    #   @!attribute [rw] $1
    #     $2
    #     @return [Array<int>]
    # Define a new Integer Array accessor
    def self.array_integer_accessor(symbol, description='')
      mappings[symbol] = ArrayMapping.new(IntegerMapping.new, description)
      attr_accessor symbol
    end

    # @macro [attach] attr_ip_address_accessor
    #   @!attribute [rw] $1
    #     $2
    #     @return [int]
    # Define a new IP Address accessor
    def self.attr_ip_address_accessor(symbol, description='')
      mappings[symbol] = IPAddressMapping.new(description)
      attr_accessor symbol
    end

    # @macro [attach] array_ip_address_accessor
    #   @!attribute [rw] $1
    #     $2
    #     @return [Array<int>]
    # Define a new IP Address Array accessor
    def self.array_ip_address_accessor(symbol, description='')
      mappings[symbol] = ArrayMapping.new(IPAddressMapping.new, description)
      attr_accessor symbol
    end

    # @macro [attach] attr_object_accessor
    #   @!attribute [rw] $1
    #     $3
    #     @return [$2]
    # Define a new Object accessor
    def self.attr_object_accessor(symbol, klass, description='')
      mappings[symbol] = ObjectMapping.new(klass, description)
      attr_accessor symbol
    end

    # @macro [attach] array_object_accessor
    #   @!attribute [rw] $1
    #     $3
    #     @return [Array<$2>]
    # Define a new Object Array accessor
    def self.array_object_accessor(symbol, klass, description='')
      mappings[symbol] = ArrayMapping.new(ObjectMapping.new(klass), description)
      attr_accessor symbol
    end

    # @macro [attach] attr_string_accessor
    #   @!attribute [rw] $1
    #     $2
    #     @return [String]
    # Define a new String accessor
    def self.attr_string_accessor(symbol, description='')
      mappings[symbol] = StringMapping.new(description)
      attr_accessor symbol
    end

    # @macro [attach] array_string_accessor
    #   @!attribute [rw] $1
    #     $2
    #     @return [Array<String>]
    # Define a new String Array accessor
    def self.array_string_accessor(symbol, description='')
      mappings[symbol] = ArrayMapping.new(StringMapping.new, description)
      attr_accessor symbol
    end

    # @endgroup

  end

end

class Object
  def to_savon_data
    self
  end
end
