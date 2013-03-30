module SavonHelper

  module DSL

    public

    # @!group DSL to define attributes mapping

    # @macro [attach] attr_boolean_accessor
    #   @!attribute [rw] $3
    #     $2
    #     @return [Boolean]
    # Define a new Boolean accessor
    # @param accessor [Symbol] The accessor to be created
    # @param description [String] The description for this accessor
    # @param alias_accessor [Symbol] An Alias for the accessor
    # @return [void]
    def attr_boolean_accessor(accessor, description='', alias_accessor=accessor)
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
    def array_boolean_accessor(accessor, description='', alias_accessor=accessor)
      create_accessor(accessor, alias_accessor, ArrayMapping.new(BooleanMapping.new, description))
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
    def attr_integer_accessor(accessor, description='', alias_accessor=accessor)
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
    def array_integer_accessor(accessor, description='', alias_accessor=accessor)
      create_accessor(accessor, alias_accessor, ArrayMapping.new(IntegerMapping.new, description))
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
    def attr_float_accessor(accessor, description='', alias_accessor=accessor)
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
    def array_float__accessor(accessor, description='', alias_accessor=accessor)
      create_accessor(accessor, alias_accessor, ArrayMapping.new(FloatMapping.new, description))
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
    def attr_double_accessor(accessor, description='', alias_accessor=accessor)
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
    def array_double_accessor(accessor, description='', alias_accessor=accessor)
      create_accessor(accessor, alias_accessor, ArrayMapping.new(FloatMapping.new, description))
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
    def attr_string_accessor(accessor, description='', alias_accessor=accessor)
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
    def array_string_accessor(accessor, description='', alias_accessor=accessor)
      create_accessor(accessor, alias_accessor, ArrayMapping.new(StringMapping.new, description))
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
    def attr_ip_address_accessor(accessor, description='', alias_accessor=accessor)
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
    def array_ip_address_accessor(accessor, description='', alias_accessor=accessor)
      create_accessor(accessor, alias_accessor, ArrayMapping.new(IPAddressMapping.new, description))
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
    def attr_datetime_accessor(accessor, description='', alias_accessor=accessor)
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
    def array_datetime_accessor(accessor, description='', alias_accessor=accessor)
      create_accessor(accessor, alias_accessor, ArrayMapping.new(DatetimeMapping.new, description))
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
    def attr_enum_accessor(accessor, enum, description='', alias_accessor=accessor)
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
    def array_enum_accessor(accessor, enum, description='', alias_accessor=accessor)
      create_accessor(accessor, alias_accessor, ArrayMapping.new(EnumMapping.new(enum), description))
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
    def hint_object_accessor(accessor, klass, description='', alias_accessor=accessor)
      create_accessor(accessor, alias_accessor, HintMapping.new(klass, description))
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
    def attr_object_accessor(accessor, klass, description='', alias_accessor=accessor)
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
    def array_object_accessor(accessor, klass, description='', alias_accessor=accessor)
      create_accessor(accessor, alias_accessor, ArrayMapping.new(ObjectMapping.new(klass, description)))
    end

    private

    # Create the specified accessor and it's alias
    # @param accessor [Symbol] The accessor
    # @param alias_accessor [Symbol] The accessor alias
    # @return [void]
    def create_accessor(accessor, alias_accessor, mapping)
      type_mappings[accessor] = mapping
      attr_accessor accessor
      create_alias(accessor, alias_accessor)
    end

    # Create the specified  alias
    # @param accessor [Symbol] The accessor
    # @param alias_accessor [Symbol] The accessor alias
    # @return [void]
    def create_alias(accessor, alias_accessor)
      if alias_accessor != accessor
        alias_method alias_accessor, accessor
        alias_method alias_accessor.to_s + "=", accessor.to_s + "="
      end
    end

    # @!endgroup

  end
end