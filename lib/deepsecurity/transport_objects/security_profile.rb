module DeepSecurity

  # Represents a Security Profile container that can be assigned to other Computers by ID using their HostTransport object.
  class SecurityProfile < TransportObject

    attr_integer_accessor :id,
                          "SecurityProfileTransport ID"
    attr_string_accessor :description,
                         "SecurityProfileTransport description"
    attr_string_accessor :name,
                         "SecurityProfileTransport name"
    array_integer_accessor :dpi_rule_i_ds,
                           "Array of assigned DPIRuleTransport IDs",
                           :dpi_rule_ids
    attr_enum_accessor :dpi_state,
                       EnumSecurityProfileDPIState,
                       "Assigned EnumSecurityProfileDPIState, e.g., :on, :off, :passiv, :inherited"
    attr_integer_accessor :anti_malware_manual_id,
                          "Anti Malware Manual ID"
    attr_boolean_accessor :anti_malware_manual_inherit,
                          "Anti Malware Manual Inherit"
    attr_integer_accessor :anti_malware_real_time_id,
                          "Anti Malware Real Time ID"
    attr_boolean_accessor :anti_malware_real_time_inherit,
                          "Anti Malware Real Time Inherit"
    attr_integer_accessor :anti_malware_real_time_schedule_id,
                          "Anti Malware Real Time Schedule ID"
    attr_integer_accessor :anti_malware_scheduled_id,
                          "Anti Malware Scheduled ID"
    attr_boolean_accessor :anti_malware_scheduled_inherit,
                          "Anti Malware Scheduled Inherit"
    attr_enum_accessor :anti_malware_state,
                       EnumSecurityProfileAntiMalwareState,
                       "Assigned EnumSecurityProfileAntiMalwareState, e.g., :on, :off, :inherited"
    array_integer_accessor :application_type_i_ds,
                           "Array of assigned ApplicationTypeTransport IDs",
                           :application_type_ids
    array_integer_accessor :firewall_rule_i_ds,
                           "Array of assigned FirewallRuleTransport IDs",
                           :firewall_rule_ids
    attr_enum_accessor :firewall_state,
                       EnumSecurityProfileFirewallState,
                       "Assigned EnumSecurityProfileFirewallState, e.g., :on, :off, :inherited"
    array_integer_accessor :integrity_rule_i_ds,
                           "Array of assigned IntegrityMonitoringRuleTransport IDs",
                           :integrity_rule_ids
    attr_enum_accessor :integrity_state,
                       EnumSecurityProfileIntegrityState,
                       "Assigned EnumSecurityProfileIntegrityState, e.g., :on, :off, :inherited"
    array_integer_accessor :log_inspection_rule_i_ds,
                           "Array of assigned LogInspectionRuleTransport IDs",
                           :log_inspection_rule_ids
    attr_enum_accessor :log_inspection_state,
                       EnumSecurityProfileLogInspectionState,
                       "Assigned EnumSecurityProfileLogInspectionState, e.g., :on, :off, :inherited"
    attr_enum_accessor :recommendation_state,
                       EnumSecurityProfileRecommendationState,
                       "Assigned EnumSecurityProfileRecommendationState, e.g., :on, :off, :inherited"
    attr_integer_accessor :schedule_id,
                          "Assigned ScheduleTransport ID"
    attr_integer_accessor :stateful_configuration_id,
                          "Assigned StatefulConfigurationTransport ID"

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