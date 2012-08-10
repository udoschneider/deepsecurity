module DeepSecurity

  # Represents a DPI Rule that can be accessed to read, update, or when creating new DPI Rules. Creating and updating
  # DPI Rules is considered advanced and not a routine or repetitive operation. Changing some configuration options,
  # such as includePacketData or raiseAlert are reasonable; however, creating a new DPI rule from scratch
  # programmatically should only be done if full testing of the ruleXML content has been performed prior.
  #
  # When creating a new rule, if possible it is recommended that an existing base rule is retrieved first, then
  # modified to reflect the new rule, and saved as the new rule.
  #
  # Once a new rule has been created and saved, the returned transport object from the save rule method should be used
  # for all subsequent configuration operations for the life of the object. The reason for this is that the Manager will
  # populate some fields during the save operation, such as rule ID, and these fields will not be present if you do not
  # use the returned version after saving.
  class DPIRule < TransportObject

    attr_integer_accessor :id, "ID"
    attr_string_accessor :name, "Name"
    attr_string_accessor :description, "Description"
    attr_string_accessor :tbuid, "Internal TBUID of a Trend Micro issued DPI Rule"
    attr_integer_accessor :application_type_id, "ApplicationTypeTransport ID this rule is assigned to"
    attr_boolean_accessor :authoritative, "Whether the rule is an internal read only Trend Micro rule"
    attr_double_accessor :cvss_score, "Final calculated CVSS score of the vulnerability information. A rule may resolve multiple vulnerabilities, so this will always be the
    highest CVSS score."
    attr_boolean_accessor :detect_only, "Whether the rule is detect only"
    attr_boolean_accessor :disable_event, "Whether the rule is disabled"
    attr_boolean_accessor :event_on_packet_drop, "Whether the rule should trigger an event when the connection is dropped"
    attr_boolean_accessor :event_on_packet_modify, "Whether the rule should trigger an event when a packet is modified by a rule
    (uncommon)"
    attr_string_accessor :identifier, "Public identifier of the filter used by Trend Micro to track filters"
    attr_boolean_accessor :ignore_recommendations, "Whether the Recommendation Engine should ignore this rule"
    attr_boolean_accessor :include_packet_data, "Whether this rule events should include packet data"
    attr_datetime_accessor :issued, "Date this rule was issued"
    attr_enum_accessor :pattern_action, EnumDPIRuleAction, "Action for START_END_PATTERNS type rule, e.g., DROP_CLOSE, LOG_ONLY"
    attr_boolean_accessor :pattern_case_sensitive, "Whether a START_END_PATTERNS type rule should consider case sensitivity"
    attr_string_accessor :pattern_end, "End pattern"
    attr_enum_accessor :pattern_if, EnumDPIRuleIf, "Trigger if a START_END_PATTERNS type rule meets the criteria, e.g.,
    ALL_PATTERNS_FOUND, ANY_PATTERNS_FOUND, NO_PATTERNS_FOUND"
    attr_string_accessor :pattern_patterns, "A newline separated list of strings which will be used by a START_END_PATTERNS type rule"
    attr_string_accessor :pattern_start, "Start pattern"
    attr_enum_accessor :priority, EnumDPIRulePriority, "Rule priority, e.g., HIGHEST, NORMAL, LOWEST"
    attr_boolean_accessor :raise_alert, "Whether an alert should be raised when the
    rule triggers"
    attr_string_accessor :rule_xml, "Rule XML of a CUSTOM_XML type rule. This may not be available for rules that have
    thirdBrigade set to TRUE"
    attr_integer_accessor :schedule_id, "ScheduleTransport ID assigned to this rule"
    attr_enum_accessor :severity, EnumDPIRuleSeverity, "Severity, e.g., CRITICAL, LOW"
    attr_enum_accessor :signature_action, EnumDPIRuleAction, "Action for SIGNATURE type rule, e.g., DROP_CLOSE, LOG_ONLY"
    attr_boolean_accessor :signature_case_sensitive, "Whether a SIGNATURE type rule should consider case sensitivity"
    attr_string_accessor :signature_signature, "Signature string which will be used by a SIGNATURE type rule"
    attr_enum_accessor :template_type, EnumDPIRuleTemplateType, "Rule Type, e.g., CUSTOM_XML, SIGNATURE, START_END PATTERNS"

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
