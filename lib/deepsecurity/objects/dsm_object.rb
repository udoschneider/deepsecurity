module DeepSecurity

  class DSMObject

    attr_accessor :dsm

    @@ivar_type_mapping = Hash.new()
    @@cache_aspects = Hash.new()

    def vars
      [@@ivar_type_mapping, @@cache_aspects]
    end

    def self.ivar_type_mapping
      mapping = @@ivar_type_mapping[self]
      return mapping if !mapping.nil?
      @@ivar_type_mapping[self] = Hash.new()
      @@ivar_type_mapping[self]
    end

    def ivar_type_mapping
      self.class.ivar_type_mapping
    end

    def self.cache_aspects
      aspect = @@cache_aspects[self]
      return aspect if !aspect.nil?
      @@cache_aspects[self] = Set.new()
      @@cache_aspects[self]
    end

    def cache_aspects
      self.class.cache_aspects
    end

    def self.array_integer_accessor(*symbols)
      symbols.each do |each|
        ivar_type_mapping[each] = {:type => :array, :element_type => :integer}
        attr_accessor each
      end
    end

    def self.array_string_accessor(*symbols)
      symbols.each do |each|
        ivar_type_mapping[each] = {:type => :array, :element_type => :string}
        attr_accessor each
      end
    end

    def self.attr_boolean_accessor(*symbols)
      symbols.each do |each|
        ivar_type_mapping[each] = :boolean
        attr_accessor each
      end
    end

    def self.attr_datetime_accessor(*symbols)
      symbols.each do |each|
        ivar_type_mapping[each] = :datetime
        attr_accessor each
      end
    end

    def self.attr_enum_accessor(hash, *symbols)
      symbols.each do |each|
        ivar_type_mapping[each] = {:type => :enum, :enum => hash}
        attr_accessor each
      end
    end

    def self.attr_float_accessor(*symbols)
      symbols.each do |each|
        ivar_type_mapping[each] = :float
        attr_accessor each
      end
    end

    def self.attr_integer_accessor(*symbols)
      symbols.each do |each|
        ivar_type_mapping[each] = :integer
        attr_accessor each
      end
    end

    def self.attr_ip_address_accessor(*symbols)
      self.attr_string_accessor(*symbols)
    end

    def self.attr_object_accessor(object_class, *symbols)
      symbols.each do |each|
        ivar_type_mapping[each] = {:type => :class, :class => object_class}
        attr_accessor each
      end
    end

    def self.attr_string_accessor(*symbols)
      symbols.each do |each|
        ivar_type_mapping[each] = :string
        attr_accessor each
      end
    end

    def self.cache_by_aspect(*symbols)
      symbols.each { |each| cache_aspects.add(each) }
    end

    def self.cache_key(aspect, value)
      "#{self}-#{aspect}-#{value}"
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
      # puts "#{__method__}"
      cache_aspects.each { |aspect|
        # puts "Store #{self.to_s} as #{self.cache_key(aspect)}"
        cache.store(self.cache_key(aspect), self) }
    end

    def self.from_hash(dsm, hash)
      instance = self.new()
      instance.dsm = dsm
      instance.fill_from_hash(hash)
      instance.store_in_cache if instance.cachable?
      instance
    end

    def fill_from_hash(hash)
      hash.each do |ivar_name, value|
        instance_variable_set("@#{ivar_name}", value_for_ivar(ivar_name, value))
      end
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
      type = ivar_type_mapping[ivar_name]
      raise_ivar_type_not_defined(ivar_name, type, value) if type.nil?
      type_value_for_ivar(type, ivar_name, value)
    end

    def type_value_for_ivar(type, ivar_name, value)
      return value.to_s if type.nil?
      return nil if value.nil?
      return typecast_string(value) if type == :string
      return typecast_boolean(value) if type == :boolean
      return nil if value.blank?
      return typecast_integer(value) if type == :integer
      return typecast_float(value) if type == :float
      return typecast_datetime(value) if type == :datetime
      if type.class == Hash
        if type[:type] == :enum
          return_value = type[:enum][value]
          raise "Unknown enum value \"#{value}\" in #{type[:enum]}" if return_value.nil?
          return return_value
        end
        if type[:type] == :class
          object_class = type[:class]
          return nil if object_class.nil?
          return object_class.new(@dsm, value)
        end
        if type[:type] == :array
          element_type = type[:element_type]
          return value[:item].collect { |item| type_value_for_ivar(element_type, ivar_name, item) }
        end
      end
      raise_type_mapping_not_defined(ivar_name, type, value)
      nil
    end

    def value_from_ivar(ivar_name, value)
      type = ivar_type_mapping[ivar_name]
      raise_ivar_type_not_defined(ivar_name, type, value) if type.nil?
      type_value_from_ivar(type, ivar_name, value)
    end

    def type_value_from_ivar(type, ivar_name, value)
      return value.to_s if type.nil?
      return nil if value.nil?
      return value.to_s if type == :string
      return value.to_s if type == :boolean
      return nil if value.blank?
      return value.to_s if type == :integer
      return value.to_s if type == :float
      return value.to_s if type == :datetime
      if type.class == Hash
        if type[:type] == :enum
          return_value = type[:enum].key(value)
          raise "Unknown enum value \"#{value.inspect}\" in #{type[:enum].inspect}" if return_value.nil?
          return return_value
        end
        if type[:type] == :class
          raise "Implement me!"
          object_class = type[:class]
          return nil if object_class.nil?
          return object_class.new(@dsm, value)
        end
      end
      raise_type_mapping_not_defined(ivar_name, type, value)
      nil
    end

    def as_hash
      hash = Hash.new()
      ivar_type_mapping.keys.each do |ivar_name|
        value = value_from_ivar(ivar_name, instance_variable_get("@#{ivar_name}"))
        hash[ivar_name.to_sym] = value unless value.nil?
      end
      hash
    end

    def typecast_datetime(value)
      DateTime.parse(value.to_s)
    end

    def typecast_float(value)
      value.to_f
    end

    def typecast_boolean(value)
      (value.to_s == "true")
    end

    def typecast_integer(value)
      value.to_i
    end

    def typecast_string(value)
      value.to_s
    end

    def to_yaml_properties
      instance_variables.reject { |each| each == :@dsm }
    end

  end


end
