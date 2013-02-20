module DeepSecurity
# This class encapsulates a missing TypeMapping
  class MissingTypeMappingException < Exception

    def self.origin(klass, ivar_name, value)
      self.new("No type mapping for #{klass}@#{ivar_name} = #{value}!")
    end
  end

end