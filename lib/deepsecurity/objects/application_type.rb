module DeepSecurity

  class ApplicationType < DSMObject

    attr_integer_accessor :id
    attr_string_accessor :description, :name, :tbuid
    attr_enum_accessor DeepSecurity::EnumDirection, :direction
    attr_boolean_accessor :ignore_recommendations
    attr_object_accessor ProtocolICMP, :protocol_icmp
    attr_object_accessor ProtocolPortBased, :protocol_port_based
    attr_enum_accessor EnumApplicationTypeProtocolType, :protocol_type
    attr_boolean_accessor :authoritative

    cache_by_aspect :id, :name

  end

  class Manager

    def application_types
      cache.fetch(ApplicationType.cache_key(:all, :all)) do
        request_array("application_type_retrieve_all", ApplicationType)
      end
    end

    def application_type(id)
      cache.fetch(ApplicationType.cache_key(:id, id)) do
        request_object("application_type_retrieve", ApplicationType, {:id => id})
      end
    end

    def application_type_by_name(name)
      cache.fetch(ApplicationType.cache_key(:name, name)) do
        request_object("application_type_retrieve_by_name", ApplicationType, {:name => name})
      end
    end

  end

end