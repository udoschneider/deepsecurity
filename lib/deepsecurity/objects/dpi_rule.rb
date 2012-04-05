module DeepSecurity

  class DPIRule < DSMObject

    attr_integer_accessor :id
    attr_string_accessor :name, :description, :tbuid
    attr_integer_accessor :application_type_id
    attr_boolean_accessor :authoritative
    attr_float_accessor :cvss_score
    attr_boolean_accessor :detect_only, :disable_event, :event_on_packet_drop, :event_on_packet_modify
    attr_string_accessor :identifier
    attr_boolean_accessor :ignore_recommendations, :include_packet_data
    attr_datetime_accessor :issued
    attr_enum_accessor EnumDPIRuleAction, :pattern_action
    attr_boolean_accessor :pattern_case_sensitive
    attr_string_accessor :pattern_end
    attr_enum_accessor EnumDPIRuleIf, :pattern_if
    attr_string_accessor :pattern_patterns, :pattern_start
    attr_enum_accessor EnumDPIRulePriority, :priority
    attr_boolean_accessor :raise_alert
    attr_string_accessor :rule_xml
    attr_integer_accessor :schedule_id
    attr_enum_accessor EnumDPIRuleSeverity, :severity
    attr_enum_accessor EnumDPIRuleAction, :signature_action
    attr_boolean_accessor :signature_case_sensitive
    attr_string_accessor :signature_signature
    attr_enum_accessor EnumDPIRuleTemplateType, :template_type

    cache_by_aspect :id, :name

    def application_type
      @dsm.application_type(@application_type_id)
    end

  end

  class Manager

    def dpi_rules
      cache.fetch(DPIRule.cache_key(:all, :all)) do
        request_array("dpi_rule_retrieve_all", DPIRule)
      end
    end

    def dpi_rule(id)
      cache.fetch(DPIRule.cache_key(:id, id)) do
        request_object("dpi_rule_retrieve", DPIRule, {:id => id})
      end
    end

    def dpi_rule_by_name(name)
      cache.fetch(DPIRule.cache_key(:name, name)) do
        request_object("dpi_rule_retrieve_by_name", DPIRule, {:name => name})
      end
    end

  end

end
