module DeepSecurity

  # An object that holds detailed information about one computer object. All the "overall" fields are fields created by
  # merging states of potentially multiple endpoints (i.e., Agent + Appliance).
  class HostDetail < Host

    attr_string_accessor :anti_malware_classic_pattern_version,
                         "Current version of the classic Anti-Malware pattern"
    attr_string_accessor :anti_malware_engine_version,
                         "Current version of the Anti-Malware engine"
    attr_string_accessor :anti_malware_intelli_trap_exception_version,
                         "Current version of the IntelliTrap exception pattern"
    attr_string_accessor :anti_malware_intelli_trap_version,
                         "Current version of the IntelliTrap pattern"
    attr_string_accessor :anti_malware_smart_scan_pattern_version,
                         "Current version of the Smart Scan pattern"
    attr_string_accessor :anti_malware_spyware_pattern_version,
                         "Current version of the Spyware pattern"
    attr_string_accessor :host_group_name,
                         "Name of Group this computer belongs to"
    attr_string_accessor :cloud_object_image_id,
                         "Cloud Object Image Id"
    attr_string_accessor :cloud_object_instance_id,
                         "Cloud Object Instance Id"
    attr_string_accessor :cloud_object_internal_unique_id,
                         "Cloud Object Internal Unique Id"
    attr_string_accessor :cloud_object_security_group_ids,
                         "Cloud Object Security Group Ids"
    attr_enum_accessor :cloud_object_type,
                       EnumCloudObjectType,
                       "Cloud Object Type"
    attr_enum_accessor :host_light,
                       EnumHostLight,
                       "Current color that represents the computers status"
    attr_datetime_accessor :last_anit_malware_scheduled_scan,
                           "Last time an Anti-Malware scheduled scan was performed"
    attr_datetime_accessor :last_anti_malware_event,
                           "The time of the most recent Anti-Malware event for this computer"
    attr_datetime_accessor :last_anti_malware_manual_scan,
                           "Last time an Anti-Malware manual scan was performed"
    attr_datetime_accessor :last_dpi_event,
                           "The time of the most recent DPI Event for this computer"
    attr_datetime_accessor :last_firewall_event,
                           "The time of the most recent Firewall Event for this computer"

    attr_ip_address_accessor :last_ip_used,
                             "The last IP that was used for this computer during communication with the manager"
    attr_datetime_accessor :last_integrity_monitoring_event,
                           "The time of the most recent Integrity Monitoring Event for this computer"
    attr_datetime_accessor :last_log_inspection_event,
                           "The time of the most recent Log Inspection Event for this computer"
    attr_integer_accessor :light,
                          "An integer representing the computers status light"
    attr_boolean_accessor :locked,
                          "The locked state of the computer"
    attr_string_accessor :overall_anti_malware_status,
                         "Overall Anti-Malware status of the computer"
    attr_string_accessor :overall_dpi_status,
                         "Overall DPI status of the computer"
    attr_string_accessor :overall_firewall_status,
                         "Overall Firewall status of the computer"
    attr_string_accessor :overall_integrity_monitoring_status,
                         "Overall Integrity Monitoring status of the computer"
    attr_datetime_accessor :overall_last_recommendation_scan,
                           "The time of the last recommendation scan"
    attr_datetime_accessor :overall_last_successful_communication,
                           "The time of the last communication with the Manager"
    attr_datetime_accessor :overall_last_successful_update,
                           "The time of the last successful Configuration Update"
    attr_datetime_accessor :overall_last_update_required,
                           "The time the last configuration update was required at the manager"
    attr_string_accessor :overall_log_inspection_status,
                         "Overall Log Inspection status of the computer"
    attr_string_accessor :overall_status,
                         "Overall status of the computer"
    attr_string_accessor :overall_version,
                         "Overall version of the computer"
    attr_string_accessor :security_profile_name,
                         "Name of the security profile assigned to the computer"
    attr_string_accessor :virtual_name,
                         "Internal virtual name (only populated if this is a computer provisioned through vCenter)"
    attr_string_accessor :virtual_uuid,
                         "Internal virtual UUID (only populated if this is a computer provisioned through vCenter)"
    array_integer_accessor :component_klasses,
                           "Array of class ids for components"
    array_string_accessor :component_names,
                          "Array of component names"
    array_integer_accessor :component_types,
                           "Array of component types"
    array_string_accessor :component_versions,
                          "Array of component versions"
    attr_string_accessor :overall_web_reputation_status,
                         "Overall Web Reputation status of the computer"
    attr_datetime_accessor :last_web_reputation_event,
                           "The time of the most recent Web Reputation event for this computer"

    array_object_accessor :host_interfaces,
                          HostInterface

    # cache_by_aspect :id, :name

  end

  class Manager

    # @!group High-Level SOAP Wrapper

    # Return all HostDetails matching the hosts filter with the given detail level
    # @param host_filter [HostFilter]
    # @param detail_level [EnumHostDetailLevel]
    # @return [Array<HostDetail>]
    def host_details(host_filter, detail_level)
      cache.fetch(HostDetail.cache_key(:all, :all)) do
        interface.hostDetailRetrieve(host_filter, detail_level)
      end
    end

    # @!endgroup

  end

  class SOAPInterface

    # @!group Low-Level SOAP Wrapper

    # Retrieves the detail information of hosts.
    #
    # SYNTAX
    #   public HostDetailTransport[] hostDetailRetrieve(HostFilterTransport hostFilter, EnumHostDetailLevel hostDetailLevel, String sID)
    #
    # PARAMETERS
    #   hostFilter Restricts the retrieved hosts by host, group, or security profile
    #   hostDetailLevel The detail level
    #   sID Authentication session identifier ID.
    #
    # RETURNS
    #   HostDetailTransport object array.
    def hostDetailRetrieve(hostFilter, hostDetailLevel, sID = manager.sID)
      request_array(:host_detail_retrieve, HostDetail, nil,
                    :hostFilter => hostFilter.to_savon,
                    :hostDetailLevel => EnumHostDetailLevel.key(hostDetailLevel),
                    :sID => sID)
    end

    # @!endgroup

  end

end
