# @author Udo Schneider <Udo.Schneider@homeaddress.de>

module SavonHelper

  # @abstract MappingObject is an abstract class providing methods to automatically convert from and to savon data.
  class MappingObject

    attr_reader :interface

    extend SavonHelper::DSL

    @@type_mappings = Hash.new { |hash, key| hash[key] = Hash.new }

    def initialize(interface=nil)
      @interface = interface
    end

    BLACK_LIST = [:@interface]

    def to_s
      public_vars = self.instance_variables.reject { |var|
        BLACK_LIST.include? var
      }.map { |var|
        "#{var}=\"#{instance_variable_get(var)}\""
      }.join(" ")

      "<##{self.class}:#{self.object_id.to_s(8)} #{public_vars}>"
    end

    # @!group Mapping

    # Return an initialized instance with the values from the (type-converted) hash.
    #
    # @param data [Hash] A hash of simple types as provided by Savon
    # @return [MappingObject] The initialized instance.
    def self.from_savon(data, interface)
      instance = self.new(interface)
      data.each do |key, value|
        instance.instance_variable_set("@#{key}", self.map_to_native(key, value, interface))
      end
      instance
    end

    # Return the instance as a hash of simple (type-converted) values suitable for Savon.
    #
    # @return [Hash] A hash of simple types.
    def to_savon
      hash = Hash.new()
      type_mappings.keys.each do |ivar_name|
        value = map_to_savon(ivar_name, instance_variable_get("@#{ivar_name}"))
        hash[ivar_name.to_sym] = value unless value.nil?
      end
      hash
    end

    # Return TypeMappings specific to the class
    # @return [Hash{Symbol => TypeMapping}]
    def self.type_mappings
      @@type_mappings[self]
    end

    # Return TypeMappings.
    # @return [Hash{Symbol => TypeMapping}]
    def self.all_type_mappings
      self.superclass.all_type_mappings.merge(type_mappings())
    end

    # Test if the given class understands the field definition
    # @param field [String] A dot separeted list of accessors
    # @return [Boolean]
    def self.has_attribute_chain(field)
      return true if self.method_defined?(field)
      current_class = self
      field.split('.').map(&:to_sym).all? do |each|
        # puts "Current Class: #{current_class.inspect}, Field: #{each}"
        if current_class.method_defined?(each)
          if current_class.respond_to?(:type_mappings)
            current_mapping = current_class.all_type_mappings[each]
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

    # Accessors defined by TypeMappings
    # @return [Array<Symbol>]
    def self.defined_attributes()
      self.type_mappings.keys
    end

    # Convert the instance to a JSON representation
    def to_json(*a)
      result = {}
      self.type_mappings.keys.each { |key| result[key] = self.send(key).to_json }
      {
          'json_class' => self.class.name,
          'data' => result
      }.to_json(*a)
    end

    private

    # Convert Savon data to ruby value.
    # @param mapping_name [Symbol] The name of the instance variable
    # @param data [Hash, Object]
    # @return [Object]
    def self.map_to_native(mapping_name, data, interface)
      mapping = all_type_mappings[mapping_name]
      mapping = SavonHelper.define_missing_type_mapping(self.class, mapping_name, data, type_mappings, interface) if mapping.nil?
      return nil if data.nil?
      mapping.to_native(data, interface)
    end

    # Convert Ruby value to Savon data.
    # @param mapping_name [Symbol] The name of the instance variable
    # @param value [Object]
    # @return [Hash, Object]
    def map_to_savon(mapping_name, value)
      mapping = all_type_mappings[mapping_name]
      mapping = SavonHelper.define_missing_type_mapping(self.class, mapping_name, value, type_mappings, interface) if mapping.nil?
      return nil if value.nil?
      mapping.to_savon(value)
    end

  end

end

class Object

  # Convert to Savon data.
  def to_savon
    self
  end

  # Return TypeMappings specific to the instance's class
  # @return [Hash{Symbol => TypeMapping}]
  def type_mappings
    self.class.type_mappings
  end

  # Return TypeMappings specific to the class
  # @return [Hash{Symbol => TypeMapping}]
  def self.type_mappings
    {}
  end

  # Return TypeMappings.
  # @return [Hash{Symbol => TypeMapping}]
  def all_type_mappings
    self.class.all_type_mappings()
  end

  # Return TypeMappings.
  # @return [Hash{Symbol => TypeMapping}]
  def self.all_type_mappings
    {}
  end

end

