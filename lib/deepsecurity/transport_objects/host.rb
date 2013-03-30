module DeepSecurity

  # The primary computer transport object that represents the computer systems Deep Security is aware of. Physical
  # computers, virtual machines, ESX servers, and Deep Security Virtual Appliances are all represented as HostTransport
  # objects.
  #
  # To determine a HostTransport status (e.g., Activated, Offline, Installed, etc.) the computer HostStatusTransport
  # should be retrieved and the assigned ProtectionStatusTransport objects should be inspected. The HostTransportStatus
  # will reflect the overall protection status of a computer. If protection is applied by both an in-guest Agent and
  # Virtual Appliance, then two ProtectionStatusTransport objects will be assigned. Agent and Virtual Appliance
  # protection may have different protection capabilities enabled, so inspection of all assigned
  # ProtectionStatusTransport objects should considered. Note that this is only necessary where a Virtual Appliance is
  # deployed. Computers and virtual machines that only use Agent protection may only use the HostTransportStatus.
  class Host < TransportObject

    attr_integer_accessor :id
    attr_string_accessor :name
    attr_string_accessor :description

    attr_string_accessor :display_name,
                         'Computer display name'
    attr_boolean_accessor :external,
                          'Administrative external boolean for integration purposes.'
    attr_string_accessor :external_id,
                         'Administrative external ID for integration purposes.'
    attr_integer_accessor :host_group_id,
                          'Assigned HostGroupTransport ID'
    attr_enum_accessor :host_type,
                       EnumHostType,
                       'Assigned host type'
    attr_string_accessor :platform,
                         'Computer platform'
    attr_integer_accessor :security_profile_id,
                          'Assigned SecurityProfileTransport ID'

    hint_object_accessor :host_group,
                         HostGroup,
                         'The host group this host belongs to'

    cache_by_aspect :id, :name

    # @!group High-Level Screenscraping Wrapper

    def dpi_rules_from_identifiers(rule_identifiers)
      dpi_rules = Hash.new()
      Manager.current.dpi_rules.each { |rule| dpi_rules[rule.identifier]=rule }
      rule_identifiers.map { |rule_identifier| dpi_rules[rule_identifier] }
    end

    def all_dpi_rule_identifiers
      Manager.current.dpi_rule_identifiers_for_host(@id, 0)
    end

    def assigned_dpi_rule_identifiers
      Manager.current.dpi_rule_identifiers_for_host(@id, 16)
    end

    def unassigned_dpi_rule_identifiers
      Manager.current.dpi_rule_identifiers_for_host(@id, 32)
    end

    def recommended__dpi_rule_identifiers
      Manager.current.dpi_rule_identifiers_for_host(@id, 33)
    end

    def unrecommended__dpi_rule_identifiers
      Manager.current.dpi_rule_identifiers_for_host(@id, 18)
    end

    def all_dpi_rules
      dpi_rules_from_identifiers(all_dpi_rule_identifiers())
    end

    def assigned_dpi_rules
      dpi_rules_from_identifiers(assigned_dpi_rule_identifiers())
    end

    #@!endgroup

    # @!group High-Level SOAP Wrapper

    def host_group
      manager.host_group(host_group_id.to_i)
    end

    #@!endgroup
  end

  class Manager

    # @!group High-Level SOAP Wrapper

    # Retrieves Hosts.
    # @return [Array<Host>]
    def hosts()
      cache.fetch(Host.cache_key(:all, :all)) do
        interface.hostRetrieveAll()
      end
    end

    # Retrieves a Host by ID.
    # @param id [Integer] Host ID
    # @return [Host]
    def host(id)
      cache.fetch(Host.cache_key(:id, id)) do
        interface.hostRetrieve(id)
      end
    end

    # Retrieves a Host by name.
    # @param hostname [String] hostname
    # @return [Host]
    def host_by_name(hostname)
      cache.fetch(Host.cache_key(:name, hostname)) do
        interface.hostRetrieveByName(hostname)
      end
    end

    #@!endgroup

    # @!group Low-Level Screenscraping Wrapper

    def security_profile
      Manager.current.security_progile(@security_profile_id)
    end

    def dpi_rule_identifiers_for_host(id, argument)
      payload_filters2_show_rules(id, argument)
      payload_filters2(:hostID => id, :arguments => argument).map { |hash| hash[:name].split(' ').first }
    end
    # @!endgroup

  end

  class SOAPInterface

    # @!group Low-Level SOAP Wrapper

    # Retrieves Hosts.
    #
    # SYNTAX
    #   HostTransport[] hostRetrieveAll(String sID)
    #
    # PARAMETERS
    #   sID Authentication session identifier ID.
    #
    # RETURNS
    #   HostTransport object array.
    def hostRetrieveAll(sID = manager.sID)
      request_array(:host_retrieve_all, Host, nil,
                    :sID => sID)
    end

    # Retrieves a Host by ID.
    #
    # SYNTAX
    #   HostTransport hostRetrieve(int ID, String sID)
    #
    # PARAMETERS
    #   ID Host ID.
    #   sID Authentication session identifier ID.
    #
    # RETURNS
    #   HostTransport object.
    def hostRetrieve(id, sID = manager.sID)
      request_object(:host_retrieve, Host, :id => id, :sID => sID)
    end

    # Retrieves a Host by name.
    #
    # SYNTAX
    #   HostTransport hostRetrieveByName(String hostname, String sID)
    #
    # PARAMETERS
    #   hostname Host name.
    #   sID Authentication session identifier ID.
    #
    # RETURNS
    #   HostTransport object.
    def hostRetrieveByName(hostname, sID = manager.sID)
      request_object(:host_retrieve_by_name, Host, :hostname => hostname, :sID => sID)
    end

    # @!endgroup


  end

end