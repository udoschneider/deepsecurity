module DeepSecurity

  class SecurityProfile < DSMObject

    attr_integer_accessor :id
    attr_string_accessor :description, :name
    array_integer_accessor :dpi_rule_i_ds
    alias :dpi_rule_ids :dpi_rule_i_ds
    alias :dpi_rule_ids= :dpi_rule_i_ds=
    attr_enum_accessor EnumSecurityProfileDPIState, :dpi_state
    attr_integer_accessor :anti_malware_manual_id
    attr_boolean_accessor :anti_malware_manual_inherit
    attr_integer_accessor :anti_malware_real_time_id
    attr_boolean_accessor :anti_malware_real_time_inherit
    attr_integer_accessor :anti_malware_real_time_schedule_id
    attr_integer_accessor :anti_malware_scheduled_id
    attr_boolean_accessor :anti_malware_scheduled_inherit
    attr_enum_accessor EnumSecurityProfileAntiMalwareState, :anti_malware_state
    array_integer_accessor :application_type_i_ds
    alias :application_type_ids :application_type_i_ds
    alias :application_type_ids= :application_type_i_ds=
    array_integer_accessor :firewall_rule_i_ds
    alias :firewall_rule_ids :firewall_rule_i_ds
    alias :firewall_rule_ids= :firewall_rule_i_ds=
    attr_enum_accessor EnumSecurityProfileFirewallState, :firewall_state
    array_integer_accessor :integrity_rule_i_ds
    alias :integrity_rule_ids :integrity_rule_i_ds
    alias :integrity_rule_ids= :integrity_rule_i_ds=
    attr_enum_accessor EnumSecurityProfileIntegrityState, :integrity_state
    array_integer_accessor :log_inspection_rule_i_ds
    alias :log_inspection_rule_ids :log_inspection_rule_i_ds
    alias :log_inspection_rule_ids= :log_inspection_rule_i_ds=
    attr_enum_accessor EnumSecurityProfileLogInspectionState, :log_inspection_state
    attr_enum_accessor EnumSecurityProfileRecommendationState, :recommendation_state
    attr_integer_accessor :schedule_id, :stateful_configuration_id

    cache_by_aspect :id, :name

  end

  class Manager

    def security_profiles
      cache.fetch(SecurityProfile.cache_key(:all, :all)) do
        request_array("security_profile_retrieve_all", SecurityProfile)
      end
    end

    def security_profile(id)
      cache.fetch(SecurityProfile.cache_key(:id, id)) do
        request_object("security_profile_retrieve", SecurityProfile, {:id => id})
      end
    end

    def security_profile_by_name(name)
      cache.fetch(SecurityProfile.cache_key(:name, name)) do
        request_object("security_profile_retrieve_by_name", SecurityProfile, {:name => name})
      end
    end

  end

end