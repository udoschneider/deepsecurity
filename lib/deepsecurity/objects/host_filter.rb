module DeepSecurity

  # Used as search criteria to limit the scope of objects returned by computer-related attributes, such as by a Group,
  # a Security Profile, or a specific computer. The event retrieval- related methods will require a HostFilterTransport
  # that is empty to search for all events, or with specific properties populated to limit the scope of the search. For
  # example, setting the HostFilterTransport securityProfileID property to the ID of a Security Profile will limit any
  # event retrieval method calls to events that pertain to computers with the specific Security Profile assigned.
  class HostFilter < DSMObject

    attr_integer_accessor :host_group_id, :host_id, :security_profile_id
    attr_enum_accessor EnumHostFilterType, :type

    def self.all_hosts
      instance = self.new()
      instance.type = :all_hosts
      instance
    end

    def self.hosts_in_group(host_group_id)
      instance = self.new()
      instance.type = :hosts_in_group
      instance.host_group_id = host_group_id
      instance
    end

    def self.hosts_using_security_profile(security_profile_id)
      instance = self.new()
      instance.type = :hosts_using_security_profile
      instance.security_profile_id = security_profile_id
      instance
    end

    def self.hosts_in_group_and_all_subgroups(host_group_id)
      instance = self.new()
      instance.type = :hosts_in_group_and_all_subgroups
      instance.host_group_id = host_group_id
      instance
    end

    def self.specific_host(host_id)
      instance = self.new()
      instance.type = :specific_host
      instance.host_id = host_id
      instance
    end

    def self.my_hosts
      instance = self.new()
      instance.type = :my_hosts
      instance
    end

  end

end
