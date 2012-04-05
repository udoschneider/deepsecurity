module DeepSecurity

  # Application Type Protocol enumeration.
  EnumApplicationTypeProtocolType = {
      "ICMP" => :icmp,
      "TCP" => :tcp,
      "UDP" => :udp,
      "TCP_UDP" => :tcp_udp
  }

  #  Connection direction enumeration.
  EnumDirection = {
      "INCOMING" => :incomming,
      "OUTGOING" => :outgoing
  }

  # Host/Computer type enumeration. Used to determine if the retrieve HostTransport
  # object is a VM, standard physical computer, ESX server, or Virtual Appliance.
  EnumHostType = {
      "STANDARD" => :standard,
      "ESX" => :esx,
      "APPLIANCE" => :appliance,
      "VM" => :vm
  }

  # DPI rule action enumeration.
  EnumDPIRuleAction = {
      "DROP_CLOSE" => :drop_close,
      "LOG_ONLY" => :log_only
  }

  # DPI rule start/end pattern conditional enumeration.
  EnumDPIRuleIf = {
      "ALL_PATTERNS_FOUND" => :all_patterns_found,
      "ANY_PATTERNS_FOUND" => :any_patterns_found,
      "NO_PATTERNS_FOUND" => :no_pattenrs_found
  }

  # DPI rule priority enumeration.
  EnumDPIRulePriority = {
      "HIGHEST" => :highest,
      "HIGH" => :high,
      "NORMAL" => :normal,
      "LOW" => :low,
      "LOWEST" => :lowest
  }

  # DPI rule severity enumeration.
  EnumDPIRuleSeverity = {
      "CRITICAL" => :critical,
      "HIGH" => :high,
      "MEDIUM" => :medium,
      "LOW" => :low
  }

  # DPI rule template type enumeration.
  EnumDPIRuleTemplateType = {
      "CUSTOM_XML" => :custom_xml,
      "SIGNATURE" => :signature,
      "START_END_PATTERNS" => :start_end_patterns
  }

  # Host/Computer filter type used when filtering retrieved events by Host, Group, Security Profile or specific Hosts.
  EnumHostFilterType = {
      "ALL_HOSTS" => :all_hosts,
      "HOSTS_IN_GROUP" => :hosts_in_group,
      "HOSTS_USING_SECURITY_PROFILE" => :hosts_using_security_profile,
      "HOSTS_IN_GROUP_AND_ALL_SUBGROUPS" => :hosts_in_group_and_all_subgroups,
      "SPECIFIC_HOST" => :specific_host,
      "MY_HOSTS" => :my_hosts
  }

  # Host/Computer detail level enumeration.
  EnumHostDetailLevel = {
      "LOW" => :low,
      "MEDIUM" => :medium,
      "HIGH" => :high
  }

  # ICMP protocol type enumeration.
  EnumProtocolIcmpType = {
      "ICMP_ECHO" => :icmp_echo,
      "ICMP_TIMESTAMP" => :icmp_timestamp,
      "ICMP_INFORMATION" => :icmp_information,
      "ICMP_ADDRESS_MASK" => :icmp_address_mask,
      "ICMP_MOBILE_REGISTRATION" => :icmp_mobile_registration
  }

  # Port List type enumeration.
  EnumPortType = {
      "ANY" => :any,
      "MAC" => :mac,
      "PORTS" => :ports,
      "DEFINED_LIST" => :defined_list
  }

  # Host/Computer Light color enumeration.
  EnumHostLight = {
      "GREEN" => :green,
      "YELLOW" => :yellow,
      "RED" => :red,
      "GREY" => :grey,
      "BLUE" => :blue
  }

end