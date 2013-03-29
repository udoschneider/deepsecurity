module DeepSecurity

  # Represents a computer group folder that computers can be assigned to for organizational purposes.
  class HostGroup < TransportObject

    attr_integer_accessor :id,
                          "ID"
    attr_string_accessor :name,
                         "Name"
    attr_string_accessor :description,
                         "Description"
    attr_boolean_accessor :external,
                          "Administrative external boolean for integration purposes"
    attr_string_accessor :external_id,
                         "Administrative external ID for integration purposes"
    attr_integer_accessor :parent_group_id,
                          "If the group belongs to a parent group, then this ID will be set and used to retrieve the parent group"

    hint_object_accessor :parent_group,
                         HostGroup,
                         'The paren group if existent'

    cache_by_aspect :id, :name

    # @!group High-Level SOAP Wrapper

    def parent_group
      return nil if @parent_group_id.nil?
      @dsm.host_group(@parent_group_id)
    end

    # Retrieves HostGroups.
    # @return [Array<HostGroup>]
    def self.all
      dsm.hostGroupRetrieveAll()
    end

    # Retrieves a HostGroup by ID.
    # @param [Integer] id HostGroup ID
    # @return [HostGroup]
    def self.find(id)
      dsm.hostGroupRetrieve(id)
    end

    # Retrieves a HostGroup by name.
    # @param [String] hostname hostname
    # @return [HostGroup]
    def self.find_by_name(hostname)
      dsm.hostGroupRetrieveByName(hostname)
    end
    #@!endgroup

  end

  class Manager

    # @!group Low-Level SOAP Wrapper

    # Retrieves all Host Groups.
    #
    # SYNTAX
    #   HostGroupTransport[] hostGroupRetrieveAll(String sID)
    #
    # PARAMETERS
    #   sID Authentication session identifier ID.
    #
    # RETURNS
    #   HostGroupTransport object array.
    def hostGroupRetrieveAll(sID = dsm.sID)
      cache.fetch(HostGroup.cache_key(:all, :all)) do
        request_array(:host_group_retrieve_all, HostGroup, nil,
                      :sID => sID)
      end
    end

    # Retrieves a Host Group by ID.
    #
    # SYNTAX
    #   HostGroupTransport hostGroupRetrieve(int ID, String sID)
    #
    # PARAMETERS
    #   ID  Identifying Host Group ID.
    #   sID Authentication session identifier ID.
    #
    # RETURNS
    #   HostGroupTransport object.
    def hostGroupRetrieve(id, sID = dsm.sID)
      cache.fetch(HostGroup.cache_key(:id, id)) do
        request_object(:host_group_retrieve, HostGroup,
                       :id => id,
                       :sID => sID)
      end
    end


    # Retrieves a Host Group by name.
    #
    # SYNTAX
    #   HostGroupTransport hostGroupRetrieveByName(String Name, String sID)
    #
    # PARAMETERS
    #   Name  Identifying Host Group name.
    #   sID Authentication session identifier ID.
    #
    # RETURNS
    #   HostGroupTransport object.
    def hostGroupRetrieveByName(name, sID = dsm.sID)
      cache.fetch(HostGroup.cache_key(:name, name)) do
        request_object(:host_group_retrieve_by_name, HostGroup,
                       :name => name,
                       :sID => sID)
      end
    end

    # @!endgroup

  end

end