module DeepSecurity

  class Host < DSMObject

    attr_integer_accessor :id
    attr_string_accessor :name, :description, :display_name
    attr_boolean_accessor :external
    attr_string_accessor :external_id
    attr_integer_accessor :host_group_id
    attr_enum_accessor EnumHostType, :host_type
    attr_string_accessor :platform
    attr_integer_accessor :security_profile_id

    cache_by_aspect :id, :name

  end

  class Manager

    def hosts
      cache.fetch(Host.cache_key(:all, :all)) do
        request_array("host_retrieve_all", Host)
      end
    end

    def host(id)
      cache.fetch(Host.cache_key(:id, id)) do
        request_object("host_retrieve", Host, {:id => id})
      end
    end

    def host_by_name(name)
      cache.fetch(Host.cache_key(:name, name)) do
        request_object("host_retrieve_by_name", Host, {:name => name})
      end
    end

  end

end