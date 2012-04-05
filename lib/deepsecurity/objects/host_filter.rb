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


  end

end
