# @author Udo Schneider <Udo.Schneider@homeaddress.de>

require "logger"
require "savon"

require "savon_helper/missing_type_mapping_exception"
# require "savon_helper/soap_exception"
require "savon_helper/type_mappings"
require "savon_helper/dsl"
require "savon_helper/mapping_object"
require "savon_helper/caching_object"
require "savon_helper/soap_interface"

unless String.respond_to? :blank

  class String
    def blank?
      empty?()
    end
  end

  class NilClass
    def blank?
      true
    end
  end

end

class Object

  def self.name_without_namespace
    name.split('::').last || ''
  end

end
