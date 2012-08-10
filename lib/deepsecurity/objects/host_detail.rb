module DeepSecurity

  # An object that holds detailed information about one computer object. All the "overall" fields are fields created by
  # merging states of potentially multiple endpoints (i.e., Agent + Appliance).
  class HostDetail < Host

=begin
    attr_integer_accessor :id
    attr_string_accessor :description
    attr_string_accessor :name
    attr_string_accessor :display_name
    attr_boolean_accessor :external
    attr_string_accessor :external_id
    attr_integer_accessor :host_group_id
    attr_enum_accessor EnumHostType, :host_type
    attr_string_accessor :platform
    attr_integer_accessor :security_profile_id
    # ABOVE is duplicates from Host!
=end

    attr_string_accessor :anti_malware_classic_pattern_version
    attr_string_accessor :anti_malware_engine_version
    attr_string_accessor :anti_malware_intelli_trap_exception_version
    attr_string_accessor :anti_malware_intelli_trap_version
    attr_string_accessor :anti_malware_smart_scan_pattern_version
    attr_string_accessor :anti_malware_spyware_pattern_version
    attr_string_accessor :host_group_name
    attr_enum_accessor :host_light, EnumHostLight
    attr_datetime_accessor :last_anit_malware_scheduled_scan
    attr_datetime_accessor :last_anti_malware_event
    attr_datetime_accessor :last_anti_malware_manual_scan
    attr_datetime_accessor :last_dpi_event
    attr_datetime_accessor :last_firewall_event
    attr_datetime_accessor :last_web_reputation_event
    attr_ip_address_accessor :last_ip_used
    attr_datetime_accessor :last_integrity_monitoring_event
    attr_datetime_accessor :last_log_inspection_event
    attr_integer_accessor :light
    attr_boolean_accessor :locked
    attr_string_accessor :overall_anti_malware_status
    attr_string_accessor :overall_dpi_status
    attr_string_accessor :overall_firewall_status
    attr_string_accessor :overall_integrity_monitoring_status
    attr_datetime_accessor :overall_last_recommendation_scan
    attr_datetime_accessor :overall_last_successful_communication
    attr_datetime_accessor :overall_last_successful_update
    attr_datetime_accessor :overall_last_update_required
    attr_string_accessor :overall_log_inspection_status
    attr_string_accessor :overall_status
    attr_string_accessor :overall_version
    attr_string_accessor :overall_web_reputation_status,
                         :security_profile_name
    attr_string_accessor :virtual_name
    attr_string_accessor :virtual_uuid
    array_integer_accessor :component_klasses
    array_string_accessor :component_names
    array_integer_accessor :component_types
    array_string_accessor :component_versions


    # cache_by_aspect :id, :name

  end

  class Manager

    def host_detail_retrieve(host_filter, detail_level)
      cache.fetch(HostDetail.cache_key(:all, :all)) do
        request_array("host_detail_retrieve", HostDetail, {
            :host_filter => host_filter.as_savon_data,
            :host_detail_level => EnumHostDetailLevel.key(detail_level)
        })
      end
    end

  end

end
