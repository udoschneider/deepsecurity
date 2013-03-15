module DeepSecurity

  # Used as search criteria to limit the scope of objects returned by computer-related attributes, such as by a Group,
  # a Security Profile, or a specific computer. The event retrieval- related methods will require a HostFilterTransport
  # that is empty to search for all events, or with specific properties populated to limit the scope of the search. For
  # example, setting the HostFilterTransport securityProfileID property to the ID of a Security Profile will limit any
  # event retrieval method calls to events that pertain to computers with the specific Security Profile assigned.
  class HostFilter < TransportObject

    attr_integer_accessor :hostGroupID,
                          "HostGroupTransport ID to filter computers by"
    attr_integer_accessor :hostID,
                          "HostTransport ID to filter computers by"
    attr_integer_accessor :securityProfileID,
                          "SecurityProfileTransport ID to filter computers by"
    attr_enum_accessor :type,
                       EnumHostFilterType,
                       "EnumHostFilterType to filter computers by"

    # @!group High-Level SOAP Wrapper

    # Return a new instance for all hosts.
    # @return [HostFilter]
    def self.all_hosts
      instance = self.new()
      instance.type = :all_hosts
      instance
    end

    # Return a new instance for hosts in the group defined by the given host_group_id.
    # @param [Integer] host_group_id
    # @return [HostFilter]
    def self.hosts_in_group(host_group_id)
      instance = self.new()
      instance.type = :hosts_in_group
      instance.hostGroupID = host_group_id
      instance
    end

    # Return a new instance for hosts in the security profile defined by the given security_profile_id.
    # @param [Integer] security_profile_id
    # @return [HostFilter]
    def self.hosts_using_security_profile(security_profile_id)
      instance = self.new()
      instance.type = :hosts_using_security_profile
      instance.securityProfileID = security_profile_id
      instance
    end

    # Return a new instance for hosts in the group and their subgroups defined by the given host_group_id.
    # @param [Integer] host_group_id
    # @return [HostFilter]
    def self.hosts_in_group_and_all_subgroups(host_group_id)
      instance = self.new()
      instance.type = :hosts_in_group_and_all_subgroups
      instance.hostGroupID = host_group_id
      instance
    end

    # Return a new instance for hosts defined by the given host_id.
    # @param [Integer] host_id
    # @return [HostFilter]
    def self.specific_host(host_id)
      instance = self.new()
      instance.type = :specific_host
      instance.hostID = host_id
      instance
    end

    # Return a new instance for "my" hosts.
    # @return [HostFilter]
    def self.my_hosts
      instance = self.new()
      instance.type = :my_hosts
      instance
    end

    # @!endgroup

  end

end
