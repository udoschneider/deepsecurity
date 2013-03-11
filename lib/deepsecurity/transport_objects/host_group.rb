module DeepSecurity

  class HostGroup < TransportObject

    attr_integer_accessor :id
    attr_string_accessor :name
    attr_string_accessor :description
    attr_boolean_accessor :external
    attr_string_accessor :external_id
    attr_integer_accessor :parent_group_id

    def parent_group
      return nil if @parent_group_id.nil?
      @dsm.host_group(@parent_group_id)
    end

  end

  class Manager

    def host_groups
      cache.fetch(HostGroup.cache_key(:all, :all)) do
        request_array("host_group_retrieve_all", HostGroup)
      end
    end

    def host_group(id)
      cache.fetch(HostGroup.cache_key(:id, id)) do
        request_object("host_group_retrieve", HostGroup, {:id => id})
      end
    end

    def host_group_by_name(name)
      cache.fetch(HostGroup.cache_key(:name, name)) do
        request_object("host_group_retrieve_by_name", HostGroup, {:name => name})
      end
    end

  end

end