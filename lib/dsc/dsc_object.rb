module Dsc

  class DscObject


    def self.transport_class
      raise "Subclass responsibility!"
    end

    def self.default_fields
      []
    end

    def self.default_fields_string
      default_fields.join(",")
    end

    def self.schema
      result ={}
      transport_class.mappings.each { |key, value| result[key] = value.description }
      result
    end

    def self.print_schema(output)
      schema = self.schema()
      schema.keys.sort.each do |key|
        output.puts "#{key}: #{schema[key]}"
      end
    end

    def self.fields_from_string(string)
      fields = string.split(",").map(&:strip)
      unknown_fields = fields.reject { |each| transport_class.has_attribute_chain(each) }
      raise "Unknown field found (#{unknown_fields.join(', ')}) - known fields are: #{transport_class.defined_attributes.sort.join(', ')}" unless unknown_fields.empty?
      fields
    end


  end

end