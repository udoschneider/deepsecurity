module DeepSecurity

  class Host < TransportObject

    attr_integer_accessor :id
    attr_string_accessor :name
    attr_string_accessor :description
    attr_string_accessor :display_name
    attr_boolean_accessor :external
    attr_string_accessor :external_id
    attr_integer_accessor :host_group_id
    attr_enum_accessor :host_type, EnumHostType
    attr_string_accessor :platform
    attr_integer_accessor :security_profile_id

    cache_by_aspect :id, :name

    def dpi_rules_from_identifiers(rule_identifiers)
      dpi_rules = Hash.new()
      @dsm.dpi_rules.each { |rule| dpi_rules[rule.identifier]=rule }
      rule_identifiers.map { |rule_identifier| dpi_rules[rule_identifier] }
    end

    def all_dpi_rule_identifiers
      @dsm.dpi_rule_identifiers_for_host(@id, 0)
    end

    def assigned_dpi_rule_identifiers
      @dsm.dpi_rule_identifiers_for_host(@id, 16)
    end

    def unassigned_dpi_rule_identifiers
      @dsm.dpi_rule_identifiers_for_host(@id, 32)
    end

    def recommended__dpi_rule_identifiers
      @dsm.dpi_rule_identifiers_for_host(@id, 33)
    end

    def unrecommended__dpi_rule_identifiers
      @dsm.dpi_rule_identifiers_for_host(@id, 18)
    end

    def all_dpi_rules
      dpi_rules_from_identifiers(all_dpi_rule_identifiers())
    end

    def assigned_dpi_rules
      dpi_rules_from_identifiers(assigned_dpi_rule_identifiers())
    end

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

    def security_profile
      @dsm.security_progile(@security_profile_id)
    end

    def dpi_rule_identifiers_for_host(id, argument)
      payload_filters2_show_rules(id, argument)
      payload_filters2(:hostID => id, :arguments => argument).map { |hash| hash[:name].split(' ').first }
    end

  end

end