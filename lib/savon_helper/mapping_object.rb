# @author Udo Schneider <Udo.Schneider@homeaddress.de>

module SavonHelper

  class MappingObject
    @@mappings = Hash.new()

    # @!group Request Helper

    # Send a Request to the SOAP API for method +method_name+ with the data in +soap_body+ and unwrap the response
    def send_soap(method, message = {})
      retryable(:tries => 5, :on => Errno::ECONNRESET) do
        logger.debug { "#{self.class}\##{__method__}(#{method.inspect}, #{message.inspect})" }
        response = @client.call method, :message => message
        return response.to_hash[(method.to_s+"_response").to_sym][(method.to_s+"_return").to_sym]
      end
    end

    # Helper Method deserializing the SOAP response into an object
    def request_object(method_name, object_class, arguments={})
      object_class.from_savon_data(send_soap(method_name, arguments))
    end

    # Helper Method deserializing the SOAP response into an object
    def request_array(method_name, object_class, collection_name = nil, arguments={})
      data = send_soap(method_name, arguments)
      data = data[collection_name] unless collection_name.blank?
      SavonHelper::ArrayMapping.new(SavonHelper::ObjectMapping.new(object_class)).from_savon_data(data)
    end

    # @!endgroup

    # @group Mapping

    # Return an initialized instance with the values from the (type-converted) hash. Store the instance in cache
    # if cacheable.
    # @see #store_in_cache
    #
    # @param data [Hash] A hash of simple types as provided by Savon
    # @return [MappingObject] The initialized instance.
    def self.from_savon_data(data)
      instance = self.new()
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

    # Return TypeMappings specific to the instance's class
    # @return [Hash{Symbol => TypeMapping}]
    def mappings
      self.class.mappings
    end

    # Return TypeMappingschroch specific to the class
    # @return [Hash{Symbol => TypeMapping}]
    def self.mappings
      mappings = @@mappings[self]
      return mappings if !mappings.nil?
      @@mappings[self] = Hash.new()
      @@mappings[self]
    end

    def self.has_attribute_chain(field)
      return true if self.method_defined?(field)
      current_class = self
      field.split('.').map(&:to_sym).all? do |each|
        # puts "Current Class: #{current_class.inspect}, Field: #{each}"
        if current_class.method_defined?(each)
          if current_class.respond_to?(:mappings)
            current_mapping = current_class.mappings[each]
            # puts "Mapping: #{current_mapping}"
            if !current_mapping.nil?
              current_class = current_mapping.object_klass
            else
              current_class = NilClass
            end
          else
            current_class = NilClass
          end
          true
        else
          false
        end
      end
    end

    def self.defined_attributes()
      self.mappings.keys
    end

    def to_json(*a)
      result = {}
      self.mappings.keys.each { |key| result[key] = self.send(key).to_json }
      {
          'json_class' => self.class.name,
          'data' => result
      }.to_json(*a)
    end

    # @raise [MissingTypeMappingException] if no mapping for ivar_name can be found
    def ivar_from_savon_data(ivar_name, value)
      mapping = mappings[ivar_name]
      mapping = SavonHelper.define_missing_type_mapping(self.class, ivar_name, value, mappings) if mapping.nil?
      return nil if value.nil?
      mapping.from_savon_data(value)
    end

    def ivar_to_savon_data(ivar_name, value)
      mapping = mappings[ivar_name]
      mapping = SavonHelper.define_missing_type_mapping(self.class, ivar_name, value, mappings) if mapping.nil?
      return nil if value.nil?
      return mapping.to_savon_data(value)
    end

    # @group DSL to define attributes mapping

    # @macro [attach] attr_boolean_accessor
    #   @!attribute [rw] $3
    #     $2
    #     @return [Boolean]
    # Define a new Boolean accessor
    # @param accessor [Symbol] The accessor to be created
    # @param description [String] The description for this accessor
    # @param alias_accessor [Symbol] An Alias for the accessor
    # @return [void]
    def self.attr_boolean_accessor(accessor, description='', alias_accessor=accessor)
      create_accessor(accessor, alias_accessor, BooleanMapping.new(description))
    end

    # @macro [attach] array_boolean_accessor
    #   @!attribute [rw] $3
    #     $2
    #     @return [Array<Boolean>]
    # Define a new Boolean Array accessor
    # @param accessor [Symbol] The accessor to be created
    # @param description [String] The description for this accessor
    # @param alias_accessor [Symbol] An Alias for the accessor
    # @return [void]
    def self.array_boolean_accessor(accessor, description='', alias_accessor=accessor)
      create_accessor(accessor, alias_accessor, ArrayMapping.new(BooleanMapping.new, description))
    end

    # @macro [attach] attr_datetime_accessor
    #   @!attribute [rw] $3
    #     $2
    #     @return [DateTime]
    # Define a new DateTime accessor
    # @param accessor [Symbol] The accessor to be created
    # @param description [String] The description for this accessor
    # @param alias_accessor [Symbol] An Alias for the accessor
    # @return [void]
    def self.attr_datetime_accessor(accessor, description='', alias_accessor=accessor)
      create_accessor(accessor, alias_accessor, DatetimeMapping.new(description))
    end

    # @macro [attach] array_datetime_accessor
    #   @!attribute [rw] $3
    #     $2
    #     @return [Array<DateTime>]
    # Define a new DateTime Array accessor
    # @param accessor [Symbol] The accessor to be created
    # @param description [String] The description for this accessor
    # @param alias_accessor [Symbol] An Alias for the accessor
    # @return [void]
    def self.array_datetime_accessor(accessor, description='', alias_accessor=accessor)
      create_accessor(accessor, alias_accessor, ArrayMapping.new(DatetimeMapping.new, description))
    end

    # @macro [attach] attr_double_accessor
    #   @!attribute [rw] $3
    #     $2
    #     @return [float]
    # Define a new Float accessor
    # @param accessor [Symbol] The accessor to be created
    # @param description [String] The description for this accessor
    # @param alias_accessor [Symbol] An Alias for the accessor
    # @return [void]
    def self.attr_double_accessor(accessor, description='', alias_accessor=accessor)
      create_accessor(accessor, alias_accessor, FloatMapping.new(description))
    end

    # @macro [attach] array_double__accessor
    #   @!attribute [rw] $3
    #     $2
    #     @return [Array<float>]
    # Define a new Float Array accessor
    # @param accessor [Symbol] The accessor to be created
    # @param description [String] The description for this accessor
    # @param alias_accessor [Symbol] An Alias for the accessor
    # @return [void]
    def self.array_double_accessor(accessor, description='', alias_accessor=accessor)
      create_accessor(accessor, alias_accessor, ArrayMapping.new(FloatMapping.new, description))
    end

    # @macro [attach] attr_enum_accessor
    #   @!attribute [rw] $4
    #     $3
    #     @return [$2]
    # Define a new Enum accessor
    # @param accessor [Symbol] The accessor to be created
    # @param enum [Enum] An hash of Enum to Symbol mappings
    # @param description [String] The description for this accessor
    # @param alias_accessor [Symbol] An Alias for the accessor
    # @return [void]
    def self.attr_enum_accessor(accessor, enum, description='', alias_accessor=accessor)
      create_accessor(accessor, alias_accessor, EnumMapping.new(enum, description))
    end

    # @macro [attach] array_enum_accessor
    #   @!attribute [rw] $4
    #     $3
    #     @return [Array<$2>]
    # Define a new Enum Array accessor
    # @param accessor [Symbol] The accessor to be created
    # @param enum [Enum] An hash of Enum to Symbol mappings
    # @param description [String] The description for this accessor
    # @param alias_accessor [Symbol] An Alias for the accessor
    # @return [void]
    def self.array_enum_accessor(accessor, enum, description='', alias_accessor=accessor)
      create_accessor(accessor, alias_accessor, ArrayMapping.new(EnumMapping.new(enum), description))
    end

    # @macro [attach] attr_float_accessor
    #   @!attribute [rw] $3
    #     $2
    #     @return [float]
    # Define a new Float accessor
    # @param accessor [Symbol] The accessor to be created
    # @param description [String] The description for this accessor
    # @param alias_accessor [Symbol] An Alias for the accessor
    # @return [void]
    def self.attr_float_accessor(accessor, description='', alias_accessor=accessor)
      create_accessor(accessor, alias_accessor, FloatMapping.new(description))
    end

    # @macro [attach] array_float__accessor
    #   @!attribute [rw] $3
    #     $2
    #     @return [Array<float>]
    # Define a new Float array accessor
    # @param accessor [Symbol] The accessor to be created
    # @param description [String] The description for this accessor
    # @param alias_accessor [Symbol] An Alias for the accessor
    # @return [void]
    def self.array_float__accessor(accessor, description='', alias_accessor=accessor)
      create_accessor(accessor, alias_accessor, ArrayMapping.new(FloatMapping.new, description))
    end

    # @macro [attach] attr_integer_accessor
    #   @!attribute [rw] $3
    #     $2
    #     @return [int]
    # Define a new Integer accessor
    # @param accessor [Symbol] The accessor to be created
    # @param description [String] The description for this accessor
    # @param alias_accessor [Symbol] An Alias for the accessor
    # @return [void]
    def self.attr_integer_accessor(accessor, description='', alias_accessor=accessor)
      create_accessor(accessor, alias_accessor, IntegerMapping.new(description))
    end

    # @macro [attach] array_integer_accessor
    #   @!attribute [rw] $3
    #     $2
    #     @return [Array<int>]
    # Define a new Integer Array accessor
    # @param accessor [Symbol] The accessor to be created
    # @param description [String] The description for this accessor
    # @param alias_accessor [Symbol] An Alias for the accessor
    # @return [void]
    def self.array_integer_accessor(accessor, description='', alias_accessor=accessor)
      create_accessor(accessor, alias_accessor, ArrayMapping.new(IntegerMapping.new, description))
    end

    # @macro [attach] attr_ip_address_accessor
    #   @!attribute [rw] $3
    #     $2
    #     @return [int]
    # Define a new IP Address accessor
    # @param accessor [Symbol] The accessor to be created
    # @param description [String] The description for this accessor
    # @param alias_accessor [Symbol] An Alias for the accessor
    # @return [void]
    def self.attr_ip_address_accessor(accessor, description='', alias_accessor=accessor)
      create_accessor(accessor, alias_accessor, IPAddressMapping.new(description))
    end

    # @macro [attach] array_ip_address_accessor
    #   @!attribute [rw] $3
    #     $2
    #     @return [Array<int>]
    # Define a new IP Address Array accessor
    # @param accessor [Symbol] The accessor to be created
    # @param description [String] The description for this accessor
    # @param alias_accessor [Symbol] An Alias for the accessor
    # @return [void]
    def self.array_ip_address_accessor(accessor, description='', alias_accessor=accessor)
      create_accessor(accessor, alias_accessor, ArrayMapping.new(IPAddressMapping.new, description))
    end

    # @macro [attach] attr_object_accessor
    #   @!attribute [rw] $4
    #     $3
    #     @return [$2]
    # Define a new Object accessor
    # @param accessor [Symbol] The accessor to be created
    # @param klass [Class] The class of the accessed object
    # @param description [String] The description for this accessor
    # @param alias_accessor [Symbol] An Alias for the accessor
    # @return [void]
    def self.attr_object_accessor(accessor, klass, description='', alias_accessor=accessor)
      create_accessor(accessor, alias_accessor, ObjectMapping.new(klass, description))
    end

    # @macro [attach] array_object_accessor
    #   @!attribute [rw] $4
    #     $3
    #     @return [Array<$2>]
    # Define a new Object Array accessor
    # @param accessor [Symbol] The accessor to be created
    # @param klass [Class] The class of the accessed object
    # @param description [String] The description for this accessor
    # @param alias_accessor [Symbol] An Alias for the accessor
    # @return [void]
    def self.array_object_accessor(accessor, klass, description='', alias_accessor=accessor)
      create_accessor(accessor, alias_accessor, ArrayMapping.new(ObjectMapping.new(klass, description)))
    end

    # @macro [attach] attr_string_accessor
    #   @!attribute [rw] $3
    #     $2
    #     @return [String]
    # Define a new String accessor
    # @param accessor [Symbol] The accessor to be created
    # @param description [String] The description for this accessor
    # @param alias_accessor [Symbol] An Alias for the accessor
    # @return [void]
    def self.attr_string_accessor(accessor, description='', alias_accessor=accessor)
      create_accessor(accessor, alias_accessor, StringMapping.new(description))
    end

    # @macro [attach] array_string_accessor
    #   @!attribute [rw] $3
    #     $2
    #     @return [Array<String>]
    # Define a new String Array accessor
    # @param accessor [Symbol] The accessor to be created
    # @param description [String] The description for this accessor
    # @param alias_accessor [Symbol] An Alias for the accessor
    # @return [void]
    def self.array_string_accessor(accessor, description='', alias_accessor=accessor)
      create_accessor(accessor, alias_accessor, ArrayMapping.new(StringMapping.new, description))
    end

    # @macro [attach] hint_object_accessor
    #   @!attribute [rw] $4
    #     $3
    #     @return [$2]
    # Define a new "hint" for documentation purposes. Please note, that the method has to be define elsewhere!
    # @param accessor [Symbol] The accessor to be created
    # @param description [String] The description for this accessor
    # @param alias_accessor [Symbol] An Alias for the accessor
    # @return [void]
    def self.hint_object_accessor(accessor, klass, description='', alias_accessor=accessor)
      create_accessor(accessor, alias_accessor, HintMapping.new(klass, description))
    end

    # Create the specified accessor and it's alias
    # @param accessor [Symbol] The accessor
    # @param alias_accessor [Symbol] The accessor alias
    # @return [void]
    def self.create_accessor(accessor, alias_accessor, mapping)
      mappings[accessor] = mapping
      attr_accessor accessor
      create_alias(accessor, alias_accessor)
    end

    # Create the specified  alias
    # @param accessor [Symbol] The accessor
    # @param alias_accessor [Symbol] The accessor alias
    # @return [void]
    def self.create_alias(accessor, alias_accessor)
      if alias_accessor != accessor
        alias_method alias_accessor, accessor
        alias_method alias_accessor.to_s + "=", accessor.to_s + "="
      end
    end

    # @endgroup

  end

end

class Object
  def to_savon_data
    self
  end
end

