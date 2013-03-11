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

  # Security Profile DPI configured state enumeration.
  EnumSecurityProfileDPIState = {
      "ON" => :on,
      "OFF" => :off,
      "PASSIVE" => :passive,
      "INHERITED" => :inherited
  }

  # Security Profile Anti Malware configured state enumeration.
  EnumSecurityProfileAntiMalwareState = {
      "ON" => :on,
      "OFF" => :off,
      "INHERITED" => :inherited
  }

  # Security Profile Firewall configured state enumeration.
  EnumSecurityProfileFirewallState = {
      "ON" => :on,
      "OFF" => :off,
      "INHERITED" => :inherited
  }

  # Security Profile Integrity Monitoring configured state enumeration.
  EnumSecurityProfileIntegrityState = {
      "ON" => :on,
      "OFF" => :off,
      "INHERITED" => :inherited
  }

  # Security Profile Log Inspection configured state enumeration.
  EnumSecurityProfileLogInspectionState = {
      "ON" => :on,
      "OFF" => :off,
      "INHERITED" => :inherited
  }

  # Security Profile Recommendation Engine configured state enumeration.
  EnumSecurityProfileRecommendationState = {
      "OFF" => :off,
      "ONGOING" => :ongoing
  }

  # Editable system settings enumeration.
  EnumEditableSettingKey = {
      "CONFIGURATION_AGENTCOMMUNICATIONS" => :configuration_agentcommunications,
      "CONFIGURATION_AGENTHARDENING" => :configuration_agenthardening,
      "CONFIGURATION_AGENTHARDENINGPASSWORDFLAG" => :configuration_agenthardeningpasswordflag,
      "CONFIGURATION_AGENTHARDENINGPASSWORDVALUE" => :configuration_agenthardeningpasswordvalue,
      "CONFIGURATION_AGENTINITIATEDACTIVATION" => :configuration_agentinitiatedactivation,
      "CONFIGURATION_AGENTINITIATEDACTIVATIONACTIVEHOST" => :configuration_agentinitiatedactivationactivehost,
      "CONFIGURATION_AGENTINITIATEDACTIVATIONALLOWHOSTNAME" => :configuration_agentinitiatedactivationallowhostname,
      "CONFIGURATION_AGENTINITIATEDACTIVATIONIPLIST" => :configuration_agentinitiatedactivationiplist,
      "CONFIGURATION_AGENTINITIATEDACTIVATIONSECURITYPROFILE" => :configuration_agentinitiatedactivationsecurityprofile,
      "CONFIGURATION_AGENTLOGFLUSHINTERVAL" => :configuration_agentlogflushinterval,
      "CONFIGURATION_AGENTSOCKETTIMEOUT" => :configuration_agentsockettimeout,
      "CONFIGURATION_ANTIMALWAREGLOBALMANUALSCANCONFIG" => :configuration_antimalwareglobalmanualscanconfig,
      "CONFIGURATION_ANTIMALWAREGLOBALREALTIMESCANCONFIG" => :configuration_antimalwareglobalrealtimescanconfig,
      "CONFIGURATION_ANTIMALWAREGLOBALREALTIMESCANSCHEDULECONFIG" => :configuration_antimalwareglobalrealtimescanscheduleconfig,
      "CONFIGURATION_ANTIMALWAREGLOBALSCHEDULEDSCANCONFIG" => :configuration_antimalwareglobalscheduledscanconfig,
      "CONFIGURATION_ANTIMALWARESTATE" => :configuration_antimalwarestate,
      "CONFIGURATION_AUTOMATICALLYACTIVATEVMS" => :configuration_automaticallyactivatevms,
      "CONFIGURATION_AUTOMATICALLYASSIGNSECURITYPROFILEFORVMS" => :configuration_automaticallyassignsecurityprofileforvms,
      "CONFIGURATION_AUTOMATICALLYDELETEANTIMALWAREEVENTSOLDERTHANMINUTES" => :configuration_automaticallydeleteantimalwareeventsolderthanminutes,
      "CONFIGURATION_AUTOMATICALLYDELETECOUNTERSOLDERTHANMINUTES" => :configuration_automaticallydeletecountersolderthanminutes,
      "CONFIGURATION_AUTOMATICALLYDELETECOUNTERSOLDERTHANWEEKS" => :configuration_automaticallydeletecountersolderthanweeks,
      "CONFIGURATION_AUTOMATICALLYDELETEDPIEVENTSOLDERTHANMINUTES" => :configuration_automaticallydeletedpieventsolderthanminutes,
      "CONFIGURATION_AUTOMATICALLYDELETEEVENTSOLDERTHANMINUTES" => :configuration_automaticallydeleteeventsolderthanminutes,
      "CONFIGURATION_AUTOMATICALLYDELETEEVENTSOLDERTHANWEEKS" => :configuration_automaticallydeleteeventsolderthanweeks,
      "CONFIGURATION_AUTOMATICALLYDELETEFIREWALLEVENTSOLDERTHANMINUTES" => :configuration_automaticallydeletefirewalleventsolderthanminutes,
      "CONFIGURATION_AUTOMATICALLYDELETEINTEGRITYEVENTSOLDERTHANMINUTES" => :configuration_automaticallydeleteintegrityeventsolderthanminutes,
      "CONFIGURATION_AUTOMATICALLYDELETELOGINSPECTIONEVENTSOLDERTHANMINUTES" => :configuration_automaticallydeleteloginspectioneventsolderthanminutes,
      "CONFIGURATION_AUTOMATICALLYDELETELOGSOLDERTHANMINUTES" => :configuration_automaticallydeletelogsolderthanminutes,
      "CONFIGURATION_AUTOMATICALLYDELETELOGSOLDERTHANWEEKS" => :configuration_automaticallydeletelogsolderthanweeks,
      "CONFIGURATION_AUTOMATICALLYDELETEWEBREPUTATIONEVENTSOLDERTHANMINUTES" => :configuration_automaticallydeletewebreputationeventsolderthanminutes,
      "CONFIGURATION_AUTOMATICALLYUPDATEIPS" => :configuration_automaticallyupdateips,
      "CONFIGURATION_AUTOMATICALLYUPDATEIPS" => :configuration_automaticallyupdateips,
      "CONFIGURATION_AUTOREQUIRESUPDATE" => :configuration_autorequiresupdate,
      "CONFIGURATION_AUTOUPDATEAPPLIANCE" => :configuration_autoupdateappliance,
      "CONFIGURATION_AUTOUPDATEAPPLIANCECOMPONENTAFTERACTIVATION" => :configuration_autoupdateappliancecomponentafteractivation,
      "CONFIGURATION_CANHOSTCONTACTGLOBALIAU" => :configuration_canhostcontactglobaliau,
      "CONFIGURATION_CANROAMINGAGENTUPDATECOMPONENT" => :configuration_canroamingagentupdatecomponent,
      "CONFIGURATION_COLLECTFULLANTIMALWAREEVENTS" => :configuration_collectfullantimalwareevents,
      "CONFIGURATION_COLLECTFULLINTEGRITYEVENTS" => :configuration_collectfullintegrityevents,
      "CONFIGURATION_COLLECTFULLLOGINSPECTIONEVENTS" => :configuration_collectfullloginspectionevents,
      "CONFIGURATION_COLLECTFULLPACKETLOGS" => :configuration_collectfullpacketlogs,
      "CONFIGURATION_COLLECTFULLPAYLOADLOGS" => :configuration_collectfullpayloadlogs,
      "CONFIGURATION_CONTEXTS_EXPECTEDCONTENTREGEX" => :configuration_contexts_expectedcontentregex,
      "CONFIGURATION_CONTEXTS_TESTINTERVAL" => :configuration_contexts_testinterval,
      "CONFIGURATION_CONTEXTS_TESTURI" => :configuration_contexts_testuri,
      "CONFIGURATION_DEFAULTALERTEMAIL" => :configuration_defaultalertemail,
      "CONFIGURATION_DEFAULTFORNEWADMINISTRATORSHIDEUNLICENSEDMODULES" => :configuration_defaultfornewadministratorshideunlicensedmodules,
      "CONFIGURATION_DEFAULTHEARTBEATPERIOD" => :configuration_defaultheartbeatperiod,
      "CONFIGURATION_DETECTIONENGINESTATE" => :configuration_detectionenginestate,
      "CONFIGURATION_DETECTIONENGINESTATEAUTOAPPLYANTIMALWARERULES" => :configuration_detectionenginestateautoapplyantimalwarerules,
      "CONFIGURATION_DETECTIONENGINESTATEAUTOAPPLYDPIRULES" => :configuration_detectionenginestateautoapplydpirules,
      "CONFIGURATION_DETECTIONENGINESTATEAUTOAPPLYFIREWALLRULES" => :configuration_detectionenginestateautoapplyfirewallrules,
      "CONFIGURATION_DETECTIONENGINESTATEAUTOAPPLYINTEGRITYRULES" => :configuration_detectionenginestateautoapplyintegrityrules,
      "CONFIGURATION_DETECTIONENGINESTATEAUTOAPPLYLOGINSPECTIONRULES" => :configuration_detectionenginestateautoapplyloginspectionrules,
      "CONFIGURATION_DSMGUID" => :configuration_dsmguid,
      "CONFIGURATION_DSMPORT" => :configuration_dsmport,
      "CONFIGURATION_DSMURL" => :configuration_dsmurl,
      "CONFIGURATION_ENABLEEXCLUSIVEINTERFACES" => :configuration_enableexclusiveinterfaces,
      "CONFIGURATION_ENVIRONMENTVARIABLEOVERRIDES" => :configuration_environmentvariableoverrides,
      "CONFIGURATION_ESXTPMALERTENABLED" => :configuration_esxtpmalertenabled,
      "CONFIGURATION_EXCLUSIVEINTERFACEPATTERNS" => :configuration_exclusiveinterfacepatterns,
      "CONFIGURATION_EXPORTEDFILECHARACTERENCODING" => :configuration_exportedfilecharacterencoding,
      "CONFIGURATION_FORWARDLOGS" => :configuration_forwardlogs,
      "CONFIGURATION_FORWARDLOGS_ANTIMALWARE" => :configuration_forwardlogs_antimalware,
      "CONFIGURATION_FORWARDLOGS_ANTIMALWARE_DIRECT" => :configuration_forwardlogs_antimalware_direct,
      "CONFIGURATION_FORWARDLOGS_INTEGRITY" => :configuration_forwardlogs_integrity,
      "CONFIGURATION_FORWARDLOGS_INTEGRITY_DIRECT" => :configuration_forwardlogs_integrity_direct,
      "CONFIGURATION_FORWARDLOGS_LOGINSPECTION" => :configuration_forwardlogs_loginspection,
      "CONFIGURATION_FORWARDLOGS_LOGINSPECTION_DIRECT" => :configuration_forwardlogs_loginspection_direct,
      "CONFIGURATION_FORWARDLOGS_PNP" => :configuration_forwardlogs_pnp,
      "CONFIGURATION_FORWARDLOGS_PNP_DIRECT" => :configuration_forwardlogs_pnp_direct,
      "CONFIGURATION_FORWARDLOGS_WRS" => :configuration_forwardlogs_wrs,
      "CONFIGURATION_FORWARDLOGS_WRS_DIRECT" => :configuration_forwardlogs_wrs_direct,
      "CONFIGURATION_GENERATEDEVENTSPERMINUTE_ANTIMALWARE" => :configuration_generatedeventsperminute_antimalware,
      "CONFIGURATION_GENERATEDEVENTSPERMINUTE_INTEGRITY" => :configuration_generatedeventsperminute_integrity,
      "CONFIGURATION_GENERATEDEVENTSPERMINUTE_LOGINSPECTION" => :configuration_generatedeventsperminute_loginspection,
      "CONFIGURATION_GENERATEDEVENTSPERMINUTE_PNP" => :configuration_generatedeventsperminute_pnp,
      "CONFIGURATION_GENERATEDEVENTSPERMINUTE_WRS" => :configuration_generatedeventsperminute_wrs,
      "CONFIGURATION_GLOBALSTATEFULCONFIG" => :configuration_globalstatefulconfig,
      "CONFIGURATION_HEARTBEATPORT" => :configuration_heartbeatport,
      "CONFIGURATION_INTEGRITYCRITICALRANK" => :configuration_integritycriticalrank,
      "CONFIGURATION_INTEGRITYHIGHRANK" => :configuration_integrityhighrank,
      "CONFIGURATION_INTEGRITYLOWRANK" => :configuration_integritylowrank,
      "CONFIGURATION_INTEGRITYMEDIUMRANK" => :configuration_integritymediumrank,
      "CONFIGURATION_LOGGINGOVERRIDE" => :configuration_loggingoverride,
      "CONFIGURATION_LOGINSPECTIONAPPLYTAGSTOGROUPS" => :configuration_loginspectionapplytagstogroups,
      "CONFIGURATION_LOGINSPECTIONCRITICALRANK" => :configuration_loginspectioncriticalrank,
      "CONFIGURATION_LOGINSPECTIONHIGHRANK" => :configuration_loginspectionhighrank,
      "CONFIGURATION_LOGINSPECTIONLOWRANK" => :configuration_loginspectionlowrank,
      "CONFIGURATION_LOGINSPECTIONMEDIUMRANK" => :configuration_loginspectionmediumrank,
      "CONFIGURATION_LOGINSPECTIONSTATE" => :configuration_loginspectionstate,
      "CONFIGURATION_LOGINSPECTIONSTORAGECLIP" => :configuration_loginspectionstorageclip,
      "CONFIGURATION_LOGINSPECTIONSYSLOGCLIP" => :configuration_loginspectionsyslogclip,
      "CONFIGURATION_MAXHOSTCLOCKSHIFT" => :configuration_maxhostclockshift,
      "CONFIGURATION_MAXIMUMAGENTINSTALLERSARCHIVED" => :configuration_maximumagentinstallersarchived,
      "CONFIGURATION_MAXIMUMSECURITYUPDATESARCHIVED" => :configuration_maximumsecurityupdatesarchived,
      "CONFIGURATION_MAXMISSEDHEARTBEATS" => :configuration_maxmissedheartbeats,
      "CONFIGURATION_MOTD_TEXT" => :configuration_motd_text,
      "CONFIGURATION_NETWORKCONTROLSTATE" => :configuration_networkcontrolstate,
      "CONFIGURATION_NETWORKDRIVERMODE" => :configuration_networkdrivermode,
      "CONFIGURATION_NEWVMSACTIVATIONSECURITYPROFILE" => :configuration_newvmsactivationsecurityprofile,
      "CONFIGURATION_NONNOTIFYINGSYSTEMEVENTS" => :configuration_nonnotifyingsystemevents,
      "CONFIGURATION_NONRECORDINGSYSTEMEVENTS" => :configuration_nonrecordingsystemevents,
      "CONFIGURATION_NOTIFICATIONMSGFORAM" => :configuration_notificationmsgforam,
      "CONFIGURATION_NOTIFICATIONMSGFORWP" => :configuration_notificationmsgforwp,
      "CONFIGURATION_PACKETFILTERDENYRANK" => :configuration_packetfilterdenyrank,
      "CONFIGURATION_PACKETFILTERLOGONLYRANK" => :configuration_packetfilterlogonlyrank,
      "CONFIGURATION_PACKETFILTERREJECTIONRANK" => :configuration_packetfilterrejectionrank,
      "CONFIGURATION_PACKETLOG_CACHELIFETIME" => :configuration_packetlog_cachelifetime,
      "CONFIGURATION_PACKETLOG_CACHESIZE" => :configuration_packetlog_cachesize,
      "CONFIGURATION_PACKETLOG_CACHESTALETIME" => :configuration_packetlog_cachestaletime,
      "CONFIGURATION_PACKETLOG_IGNORE" => :configuration_packetlog_ignore,
      "CONFIGURATION_PACKETLOG_KEEP" => :configuration_packetlog_keep,
      "CONFIGURATION_PACKETLOG_LOGOUTOFALLOWEDPOLICY" => :configuration_packetlog_logoutofallowedpolicy,
      "CONFIGURATION_PACKETLOG_MAXSIZE" => :configuration_packetlog_maxsize,
      "CONFIGURATION_PACKET_DRIVER_BLOCKIPV6" => :configuration_packet_driver_blockipv6,
      "CONFIGURATION_PACKET_DRIVER_BLOCKIPV6FOR8PLUS" => :configuration_packet_driver_blockipv6for8plus,
      "CONFIGURATION_PACKET_DRIVER_BLOCKSAMESRCDSTIP" => :configuration_packet_driver_blocksamesrcdstip,
      "CONFIGURATION_PACKET_DRIVER_BYPASSWAASCONNECTIONS" => :configuration_packet_driver_bypasswaasconnections,
      "CONFIGURATION_PACKET_DRIVER_CONNECTIONEVENTSICMP" => :configuration_packet_driver_connectioneventsicmp,
      "CONFIGURATION_PACKET_DRIVER_CONNECTIONEVENTSTCP" => :configuration_packet_driver_connectioneventstcp,
      "CONFIGURATION_PACKET_DRIVER_CONNECTIONEVENTSUDP" => :configuration_packet_driver_connectioneventsudp,
      "CONFIGURATION_PACKET_DRIVER_DEBUGMODE" => :configuration_packet_driver_debugmode,
      "CONFIGURATION_PACKET_DRIVER_DEBUGPACKETMAX" => :configuration_packet_driver_debugpacketmax,
      "CONFIGURATION_PACKET_DRIVER_DROP6TO4BOGONS" => :configuration_packet_driver_drop6to4bogons,
      "CONFIGURATION_PACKET_DRIVER_DROPEVASIVERETRANSMIT" => :configuration_packet_driver_dropevasiveretransmit,
      "CONFIGURATION_PACKET_DRIVER_DROPIPV6BOGONS" => :configuration_packet_driver_dropipv6bogons,
      "CONFIGURATION_PACKET_DRIVER_DROPIPV6MINMTU" => :configuration_packet_driver_dropipv6minmtu,
      "CONFIGURATION_PACKET_DRIVER_DROPIPV6RESERVED" => :configuration_packet_driver_dropipv6reserved,
      "CONFIGURATION_PACKET_DRIVER_DROPIPV6SITELOCAL" => :configuration_packet_driver_dropipv6sitelocal,
      "CONFIGURATION_PACKET_DRIVER_DROPIPV6TYPE0" => :configuration_packet_driver_dropipv6type0,
      "CONFIGURATION_PACKET_DRIVER_DROPIPZEROPAYLOAD" => :configuration_packet_driver_dropipzeropayload,
      "CONFIGURATION_PACKET_DRIVER_DROPTEREDOANOMALIES" => :configuration_packet_driver_dropteredoanomalies,
      "CONFIGURATION_PACKET_DRIVER_DROPTUNNELDEPTHEXCEEDED" => :configuration_packet_driver_droptunneldepthexceeded,
      "CONFIGURATION_PACKET_DRIVER_FILTERIPV4TUNNELS" => :configuration_packet_driver_filteripv4tunnels,
      "CONFIGURATION_PACKET_DRIVER_FILTERIPV6TUNNELS" => :configuration_packet_driver_filteripv6tunnels,
      "CONFIGURATION_PACKET_DRIVER_FRAGMINOFFSET" => :configuration_packet_driver_fragminoffset,
      "CONFIGURATION_PACKET_DRIVER_FRAGMINSIZE" => :configuration_packet_driver_fragminsize,
      "CONFIGURATION_PACKET_DRIVER_IGNORESTATUS0" => :configuration_packet_driver_ignorestatus0,
      "CONFIGURATION_PACKET_DRIVER_IGNORESTATUS1" => :configuration_packet_driver_ignorestatus1,
      "CONFIGURATION_PACKET_DRIVER_IGNORESTATUS2" => :configuration_packet_driver_ignorestatus2,
      "CONFIGURATION_PACKET_DRIVER_LOGRULES" => :configuration_packet_driver_logrules,
      "CONFIGURATION_PACKET_DRIVER_LOGSPERSEC" => :configuration_packet_driver_logspersec,
      "CONFIGURATION_PACKET_DRIVER_MAXCONNECTIONSICMP" => :configuration_packet_driver_maxconnectionsicmp,
      "CONFIGURATION_PACKET_DRIVER_MAXCONNECTIONSPERIODICCLEANUP" => :configuration_packet_driver_maxconnectionsperiodiccleanup,
      "CONFIGURATION_PACKET_DRIVER_MAXCONNECTIONSTCP" => :configuration_packet_driver_maxconnectionstcp,
      "CONFIGURATION_PACKET_DRIVER_MAXCONNECTIONSUDP" => :configuration_packet_driver_maxconnectionsudp,
      "CONFIGURATION_PACKET_DRIVER_MAXTUNNELDEPTH" => :configuration_packet_driver_maxtunneldepth,
      "CONFIGURATION_PACKET_DRIVER_NODEMAX" => :configuration_packet_driver_nodemax,
      "CONFIGURATION_PACKET_DRIVER_PASSNULLIP" => :configuration_packet_driver_passnullip,
      "CONFIGURATION_PACKET_DRIVER_PDUSNAPLENGTH" => :configuration_packet_driver_pdusnaplength,
      "CONFIGURATION_PACKET_DRIVER_PDUSTATEFUL" => :configuration_packet_driver_pdustateful,
      "CONFIGURATION_PACKET_DRIVER_PDUSTATEFULFIRST" => :configuration_packet_driver_pdustatefulfirst,
      "CONFIGURATION_PACKET_DRIVER_PDUSTATEFULPERIOD" => :configuration_packet_driver_pdustatefulperiod,
      "CONFIGURATION_PACKET_DRIVER_SETTINGSENABLED" => :configuration_packet_driver_settingsenabled,
      "CONFIGURATION_PACKET_DRIVER_SSLSESSIONSIZE" => :configuration_packet_driver_sslsessionsize,
      "CONFIGURATION_PACKET_DRIVER_SSLSESSIONTIME" => :configuration_packet_driver_sslsessiontime,
      "CONFIGURATION_PACKET_DRIVER_STRICTTEREDOPORTCHECK" => :configuration_packet_driver_strictteredoportcheck,
      "CONFIGURATION_PACKET_DRIVER_TCPMSSLIMIT" => :configuration_packet_driver_tcpmsslimit,
      "CONFIGURATION_PACKET_DRIVER_TCPSILENTRST" => :configuration_packet_driver_tcpsilentrst,
      "CONFIGURATION_PACKET_DRIVER_TIMEOUTACKSTORM" => :configuration_packet_driver_timeoutackstorm,
      "CONFIGURATION_PACKET_DRIVER_TIMEOUTBOOTSTART" => :configuration_packet_driver_timeoutbootstart,
      "CONFIGURATION_PACKET_DRIVER_TIMEOUTCLOSED" => :configuration_packet_driver_timeoutclosed,
      "CONFIGURATION_PACKET_DRIVER_TIMEOUTCLOSEWAIT" => :configuration_packet_driver_timeoutclosewait,
      "CONFIGURATION_PACKET_DRIVER_TIMEOUTCLOSING" => :configuration_packet_driver_timeoutclosing,
      "CONFIGURATION_PACKET_DRIVER_TIMEOUTCOLDSTART" => :configuration_packet_driver_timeoutcoldstart,
      "CONFIGURATION_PACKET_DRIVER_TIMEOUTCONNCLEANUP" => :configuration_packet_driver_timeoutconncleanup,
      "CONFIGURATION_PACKET_DRIVER_TIMEOUTDISCONNECT" => :configuration_packet_driver_timeoutdisconnect,
      "CONFIGURATION_PACKET_DRIVER_TIMEOUTERROR" => :configuration_packet_driver_timeouterror,
      "CONFIGURATION_PACKET_DRIVER_TIMEOUTESTAB" => :configuration_packet_driver_timeoutestab,
      "CONFIGURATION_PACKET_DRIVER_TIMEOUTFINWAIT" => :configuration_packet_driver_timeoutfinwait,
      "CONFIGURATION_PACKET_DRIVER_TIMEOUTICMP" => :configuration_packet_driver_timeouticmp,
      "CONFIGURATION_PACKET_DRIVER_TIMEOUTLASTACK" => :configuration_packet_driver_timeoutlastack,
      "CONFIGURATION_PACKET_DRIVER_TIMEOUTSYNRCVD" => :configuration_packet_driver_timeoutsynrcvd,
      "CONFIGURATION_PACKET_DRIVER_TIMEOUTSYNSENT" => :configuration_packet_driver_timeoutsynsent,
      "CONFIGURATION_PACKET_DRIVER_TIMEOUTUDP" => :configuration_packet_driver_timeoutudp,
      "CONFIGURATION_PACKET_DRIVER_VERIFYTCPCHECKSUM" => :configuration_packet_driver_verifytcpchecksum,
      "CONFIGURATION_PAYLOADFILTERCRITICALRANK" => :configuration_payloadfiltercriticalrank,
      "CONFIGURATION_PAYLOADFILTERERRORRANK" => :configuration_payloadfiltererrorrank,
      "CONFIGURATION_PAYLOADFILTERHIGHRANK" => :configuration_payloadfilterhighrank,
      "CONFIGURATION_PAYLOADFILTERLOWRANK" => :configuration_payloadfilterlowrank,
      "CONFIGURATION_PAYLOADFILTERMEDIUMRANK" => :configuration_payloadfiltermediumrank,
      "CONFIGURATION_PAYLOADLOGFIRSTPDU" => :configuration_payloadlogfirstpdu,
      "CONFIGURATION_PAYLOADLOG_CACHELIFETIME" => :configuration_payloadlog_cachelifetime,
      "CONFIGURATION_PAYLOADLOG_CACHESIZE" => :configuration_payloadlog_cachesize,
      "CONFIGURATION_PAYLOADLOG_CACHESTALETIME" => :configuration_payloadlog_cachestaletime,
      "CONFIGURATION_PAYLOADLOG_IGNORE" => :configuration_payloadlog_ignore,
      "CONFIGURATION_PAYLOADLOG_KEEP" => :configuration_payloadlog_keep,
      "CONFIGURATION_PAYLOADLOG_MAXSIZE" => :configuration_payloadlog_maxsize,
      "CONFIGURATION_PAYLOAD_DRIVER_IPFRAGSENDTIMEEXCEEDED" => :configuration_payload_driver_ipfragsendtimeexceeded,
      "CONFIGURATION_PAYLOAD_DRIVER_MAXIPFRAG" => :configuration_payload_driver_maxipfrag,
      "CONFIGURATION_PAYLOAD_DRIVER_SETTINGSENABLED" => :configuration_payload_driver_settingsenabled,
      "CONFIGURATION_PAYLOAD_DRIVER_TIMEOUTFRAGMENT" => :configuration_payload_driver_timeoutfragment,
      "CONFIGURATION_PENDINGAGENTUPDATEALERTLIMIT" => :configuration_pendingagentupdatealertlimit,
      "CONFIGURATION_PORTSTOSCAN" => :configuration_portstoscan,
      "CONFIGURATION_QUARANTINE_MAXFILESIZE" => :configuration_quarantine_maxfilesize,
      "CONFIGURATION_QUARANTINE_MAXGUESTSPACE" => :configuration_quarantine_maxguestspace,
      "CONFIGURATION_QUARANTINE_MAXQUARANTINEDSPACE" => :configuration_quarantine_maxquarantinedspace,
      "CONFIGURATION_RAISEAGENTOFFLINEERRORSFORINACTIVEVMS" => :configuration_raiseagentofflineerrorsforinactivevms,
      "CONFIGURATION_RECOMMENDATIONMONITORINTERVAL" => :configuration_recommendationmonitorinterval,
      "CONFIGURATION_RELAYUPDATESOURCE" => :configuration_relayupdatesource,
      "CONFIGURATION_RELAYUPDATESOURCE_OTHERAU_URL" => :configuration_relayupdatesource_otherau_url,
      "CONFIGURATION_SCANLIMITATION_MAXFILESCANSIZE" => :configuration_scanlimitation_maxfilescansize,
      "CONFIGURATION_SINGLEEXCLUSIVEINTERFACEENABLED" => :configuration_singleexclusiveinterfaceenabled,
      "CONFIGURATION_SMARTPROTECTIONSERVER_PROXYIDFORGLOBALSERVER" => :configuration_smartprotectionserver_proxyidforglobalserver,
      "CONFIGURATION_SMARTPROTECTIONSERVER_SMARTSCANALLOWFALLBACK" => :configuration_smartprotectionserver_smartscanallowfallback,
      "CONFIGURATION_SMARTPROTECTIONSERVER_SMARTSCANLOCALSERVERS" => :configuration_smartprotectionserver_smartscanlocalservers,
      "CONFIGURATION_SMARTPROTECTIONSERVER_SMARTSCANUSEGLOBALSERVER" => :configuration_smartprotectionserver_smartscanuseglobalserver,
      "CONFIGURATION_SMARTPROTECTIONSERVER_SMARTSCANUSEPROXYFORGLOBALSERVER" => :configuration_smartprotectionserver_smartscanuseproxyforglobalserver,
      "CONFIGURATION_SMARTPROTECTIONSERVER_WEBREPUTATIONALLOWGLOBAL" => :configuration_smartprotectionserver_webreputationallowglobal,
      "CONFIGURATION_SMARTPROTECTIONSERVER_WEBREPUTATIONLOCALRATINGSERVER" => :configuration_smartprotectionserver_webreputationlocalratingserver,
      "CONFIGURATION_SMARTPROTECTIONSERVER_WEBREPUTATIONRATINGSERVERPROXYID" => :configuration_smartprotectionserver_webreputationratingserverproxyid,
      "CONFIGURATION_SMARTPROTECTIONSERVER_WEBREPUTATIONUSELOCALRATINGSER" => :configuration_smartprotectionserver_webreputationuselocalratingser,
      "CONFIGURATION_SMARTPROTECTIONSERVER_WEBREPUTATIONUSEPROXYFORGLOBALSERVER" => :configuration_smartprotectionserver_webreputationuseproxyforglobalserver,
      "CONFIGURATION_SMARTSCANSTATE" => :configuration_smartscanstate,
      "CONFIGURATION_SPNFB_BANDWIDTHLIMITATION" => :configuration_spnfb_bandwidthlimitation,
      "CONFIGURATION_SPNFB_ENABLEFEEDBACK" => :configuration_spnfb_enablefeedback,
      "CONFIGURATION_SPNFB_ENABLESUSPICIUSFILEFEEDBACK" => :configuration_spnfb_enablesuspiciusfilefeedback,
      "CONFIGURATION_SPNFB_FEEDBACKINTEVALBYMINUTES" => :configuration_spnfb_feedbackintevalbyminutes,
      "CONFIGURATION_SPNFB_FEEDBACKINTEVALBYTHREATS" => :configuration_spnfb_feedbackintevalbythreats,
      "CONFIGURATION_SPNFB_INDUSTRYTYPE" => :configuration_spnfb_industrytype,
      "CONFIGURATION_SPYWAREAPPROVEDLIST" => :configuration_spywareapprovedlist,
      "CONFIGURATION_SYSLOGFACILITY" => :configuration_syslogfacility,
      "CONFIGURATION_SYSLOGFACILITY_ANTIMALWARE" => :configuration_syslogfacility_antimalware,
      "CONFIGURATION_SYSLOGFACILITY_INTEGRITY" => :configuration_syslogfacility_integrity,
      "CONFIGURATION_SYSLOGFACILITY_LOGINSPECTION" => :configuration_syslogfacility_loginspection,
      "CONFIGURATION_SYSLOGFACILITY_PNP" => :configuration_syslogfacility_pnp,
      "CONFIGURATION_SYSLOGFACILITY_WRS" => :configuration_syslogfacility_wrs,
      "CONFIGURATION_SYSLOGFORMAT" => :configuration_syslogformat,
      "CONFIGURATION_SYSLOGFORMAT_ANTIMALWARE" => :configuration_syslogformat_antimalware,
      "CONFIGURATION_SYSLOGFORMAT_INTEGRITY" => :configuration_syslogformat_integrity,
      "CONFIGURATION_SYSLOGFORMAT_LOGINSPECTION" => :configuration_syslogformat_loginspection,
      "CONFIGURATION_SYSLOGFORMAT_PNP" => :configuration_syslogformat_pnp,
      "CONFIGURATION_SYSLOGFORMAT_WRS" => :configuration_syslogformat_wrs,
      "CONFIGURATION_SYSLOGHOST" => :configuration_sysloghost,
      "CONFIGURATION_SYSLOGHOST_ANTIMALWARE" => :configuration_sysloghost_antimalware,
      "CONFIGURATION_SYSLOGHOST_INTEGRITY" => :configuration_sysloghost_integrity,
      "CONFIGURATION_SYSLOGHOST_LOGINSPECTION" => :configuration_sysloghost_loginspection,
      "CONFIGURATION_SYSLOGHOST_PNP" => :configuration_sysloghost_pnp,
      "CONFIGURATION_SYSLOGHOST_WRS" => :configuration_sysloghost_wrs,
      "CONFIGURATION_SYSLOGOVERRIDE" => :configuration_syslogoverride,
      "CONFIGURATION_SYSLOGOVERRIDE_ANTIMALWARE" => :configuration_syslogoverride_antimalware,
      "CONFIGURATION_SYSLOGOVERRIDE_INTEGRITY" => :configuration_syslogoverride_integrity,
      "CONFIGURATION_SYSLOGOVERRIDE_LOGINSPECTION" => :configuration_syslogoverride_loginspection,
      "CONFIGURATION_SYSLOGOVERRIDE_PNP" => :configuration_syslogoverride_pnp,
      "CONFIGURATION_SYSLOGOVERRIDE_WRS" => :configuration_syslogoverride_wrs,
      "CONFIGURATION_SYSLOGPORT" => :configuration_syslogport,
      "CONFIGURATION_SYSLOGPORT_ANTIMALWARE" => :configuration_syslogport_antimalware,
      "CONFIGURATION_SYSLOGPORT_INTEGRITY" => :configuration_syslogport_integrity,
      "CONFIGURATION_SYSLOGPORT_LOGINSPECTION" => :configuration_syslogport_loginspection,
      "CONFIGURATION_SYSLOGPORT_PNP" => :configuration_syslogport_pnp,
      "CONFIGURATION_SYSLOGPORT_WRS" => :configuration_syslogport_wrs,
      "CONFIGURATION_SYSTEMEVENTNOTIFICATIONSCRIPTS" => :configuration_systemeventnotificationscripts,
      "CONFIGURATION_SYSTEMEVENTNOTIFICATIONSEXTENDEDDESCRIPTIONS" => :configuration_systemeventnotificationsextendeddescriptions,
      "CONFIGURATION_SYSTEMEVENTNOTIFICATIONSSCRIPTSENABLED" => :configuration_systemeventnotificationsscriptsenabled,
      "CONFIGURATION_SYSTEMEVENTNOTIFICATIONSSNMPADDRESS" => :configuration_systemeventnotificationssnmpaddress,
      "CONFIGURATION_SYSTEMEVENTNOTIFICATIONSSNMPCOMMUNITY" => :configuration_systemeventnotificationssnmpcommunity,
      "CONFIGURATION_SYSTEMEVENTNOTIFICATIONSSNMPENABLED" => :configuration_systemeventnotificationssnmpenabled,
      "CONFIGURATION_SYSTEMEVENTNOTIFICATIONSSNMPPORT" => :configuration_systemeventnotificationssnmpport,
      "CONFIGURATION_SYSTEMEVENTNOTIFICATIONSSNMPRETRIES" => :configuration_systemeventnotificationssnmpretries,
      "CONFIGURATION_SYSTEMEVENTNOTIFICATIONSSNMPTIMEOUT" => :configuration_systemeventnotificationssnmptimeout,
      "CONFIGURATION_SYSTEMEVENTNOTIFICATIONSSYSLOGADDRESS" => :configuration_systemeventnotificationssyslogaddress,
      "CONFIGURATION_SYSTEMEVENTNOTIFICATIONSSYSLOGADDRESSVER" => :configuration_systemeventnotificationssyslogaddressver,
      "CONFIGURATION_SYSTEMEVENTNOTIFICATIONSSYSLOGENABLED" => :configuration_systemeventnotificationssyslogenabled,
      "CONFIGURATION_SYSTEMEVENTNOTIFICATIONSSYSLOGERROREVENTS" => :configuration_systemeventnotificationssyslogerrorevents,
      "CONFIGURATION_SYSTEMEVENTNOTIFICATIONSSYSLOGFACILITY" => :configuration_systemeventnotificationssyslogfacility,
      "CONFIGURATION_SYSTEMEVENTNOTIFICATIONSSYSLOGFORMAT" => :configuration_systemeventnotificationssyslogformat,
      "CONFIGURATION_SYSTEMEVENTNOTIFICATIONSSYSLOGIDENTIFICATION" => :configuration_systemeventnotificationssyslogidentification,
      "CONFIGURATION_SYSTEMEVENTNOTIFICATIONSSYSLOGINFOEVENTS" => :configuration_systemeventnotificationssysloginfoevents,
      "CONFIGURATION_SYSTEMEVENTNOTIFICATIONSSYSLOGPORT" => :configuration_systemeventnotificationssyslogport,
      "CONFIGURATION_SYSTEMEVENTNOTIFICATIONSSYSLOGPREPENDTIMESTAMP" => :configuration_systemeventnotificationssyslogprependtimestamp,
      "CONFIGURATION_SYSTEMEVENTNOTIFICATIONSSYSLOGWARNINGEVENTS" => :configuration_systemeventnotificationssyslogwarningevents,
      "CONFIGURATION_SYSTEMINTEGRITYHASH" => :configuration_systemintegrityhash,
      "CONFIGURATION_SYSTEMINTEGRITYSTATE" => :configuration_systemintegritystate,
      "CONFIGURATION_TRAFFICANALYSIS_FINGERPRINT_BLOCK" => :configuration_trafficanalysis_fingerprint_block,
      "CONFIGURATION_TRAFFICANALYSIS_FINGERPRINT_ENABLED" => :configuration_trafficanalysis_fingerprint_enabled,
      "CONFIGURATION_TRAFFICANALYSIS_FINGERPRINT_NOTIFY" => :configuration_trafficanalysis_fingerprint_notify,
      "CONFIGURATION_TRAFFICANALYSIS_GLOBAL_ANALYZE" => :configuration_trafficanalysis_global_analyze,
      "CONFIGURATION_TRAFFICANALYSIS_GLOBAL_ENABLED" => :configuration_trafficanalysis_global_enabled,
      "CONFIGURATION_TRAFFICANALYSIS_GLOBAL_IGNORE" => :configuration_trafficanalysis_global_ignore,
      "CONFIGURATION_TRAFFICANALYSIS_NULL_BLOCK" => :configuration_trafficanalysis_null_block,
      "CONFIGURATION_TRAFFICANALYSIS_NULL_ENABLED" => :configuration_trafficanalysis_null_enabled,
      "CONFIGURATION_TRAFFICANALYSIS_NULL_NOTIFY" => :configuration_trafficanalysis_null_notify,
      "CONFIGURATION_TRAFFICANALYSIS_SCAN_BLOCK" => :configuration_trafficanalysis_scan_block,
      "CONFIGURATION_TRAFFICANALYSIS_SCAN_ENABLED" => :configuration_trafficanalysis_scan_enabled,
      "CONFIGURATION_TRAFFICANALYSIS_SCAN_NOTIFY" => :configuration_trafficanalysis_scan_notify,
      "CONFIGURATION_TRAFFICANALYSIS_SYNFIN_BLOCK" => :configuration_trafficanalysis_synfin_block,
      "CONFIGURATION_TRAFFICANALYSIS_SYNFIN_ENABLED" => :configuration_trafficanalysis_synfin_enabled,
      "CONFIGURATION_TRAFFICANALYSIS_SYNFIN_NOTIFY" => :configuration_trafficanalysis_synfin_notify,
      "CONFIGURATION_TRAFFICANALYSIS_XMAS_BLOCK" => :configuration_trafficanalysis_xmas_block,
      "CONFIGURATION_TRAFFICANALYSIS_XMAS_ENABLED" => :configuration_trafficanalysis_xmas_enabled,
      "CONFIGURATION_TRAFFICANALYSIS_XMAS_NOTIFY" => :configuration_trafficanalysis_xmas_notify,
      "CONFIGURATION_UPDATEPROXYAUTH" => :configuration_updateproxyauth,
      "CONFIGURATION_UPDATEPROXYFLAG" => :configuration_updateproxyflag,
      "CONFIGURATION_UPDATEPROXYHOST" => :configuration_updateproxyhost,
      "CONFIGURATION_UPDATEPROXYID" => :configuration_updateproxyid,
      "CONFIGURATION_UPDATEPROXYPASS" => :configuration_updateproxypass,
      "CONFIGURATION_UPDATEPROXYPORT" => :configuration_updateproxyport,
      "CONFIGURATION_UPDATEPROXYTYPE" => :configuration_updateproxytype,
      "CONFIGURATION_UPDATEPROXYUSER" => :configuration_updateproxyuser,
      "CONFIGURATION_UPDATESOURCE" => :configuration_updatesource,
      "CONFIGURATION_UPDATESOURCE_INTRANET_PASSWORD" => :configuration_updatesource_intranet_password,
      "CONFIGURATION_UPDATESOURCE_INTRANET_UNC" => :configuration_updatesource_intranet_unc,
      "CONFIGURATION_UPDATESOURCE_INTRANET_USER" => :configuration_updatesource_intranet_user,
      "CONFIGURATION_UPDATESOURCE_OTHERAU_URL" => :configuration_updatesource_otherau_url,
      "CONFIGURATION_VSUAUTOALERT" => :configuration_vsuautoalert,
      "CONFIGURATION_VSUAUTOASSIGN" => :configuration_vsuautoassign,
      "CONFIGURATION_VULNERABILITYSHIELDSTATE" => :configuration_vulnerabilityshieldstate,
      "CONFIGURATION_WEBREPUTATIONALERTINGON" => :configuration_webreputationalertingon,
      "CONFIGURATION_WEBREPUTATIONALLOWEDDOMAINURLS" => :configuration_webreputationalloweddomainurls,
      "CONFIGURATION_WEBREPUTATIONALLOWEDPAGEURLS" => :configuration_webreputationallowedpageurls,
      "CONFIGURATION_WEBREPUTATIONBLOCKEDBYADMINISTRATORRANK" => :configuration_webreputationblockedbyadministratorrank,
      "CONFIGURATION_WEBREPUTATIONBLOCKEDDOMAINURLS" => :configuration_webreputationblockeddomainurls,
      "CONFIGURATION_WEBREPUTATIONBLOCKEDKEYWORDS" => :configuration_webreputationblockedkeywords,
      "CONFIGURATION_WEBREPUTATIONBLOCKEDPAGELINK" => :configuration_webreputationblockedpagelink,
      "CONFIGURATION_WEBREPUTATIONBLOCKEDPAGEURLS" => :configuration_webreputationblockedpageurls,
      "CONFIGURATION_WEBREPUTATIONBLOCKUNTESTEDPAGES" => :configuration_webreputationblockuntestedpages,
      "CONFIGURATION_WEBREPUTATIONDANGEROUSRANK" => :configuration_webreputationdangerousrank,
      "CONFIGURATION_WEBREPUTATIONENABLED" => :configuration_webreputationenabled,
      "CONFIGURATION_WEBREPUTATIONHIGHLYSUSPICIOUSRANK" => :configuration_webreputationhighlysuspiciousrank,
      "CONFIGURATION_WEBREPUTATIONSAFERANK" => :configuration_webreputationsaferank,
      "CONFIGURATION_WEBREPUTATIONSECURITYLEVEL" => :configuration_webreputationsecuritylevel,
      "CONFIGURATION_WEBREPUTATIONSUSPICIOUSRANK" => :configuration_webreputationsuspiciousrank,
      "CONFIGURATION_WEBREPUTATIONUNTESTEDRANK" => :configuration_webreputationuntestedrank,
      "CONFIGURATION_WEBSERVICEAPIENABLED" => :configuration_webserviceapienabled,
      "LICENSES_HISTORIC" => :licenses_historic,
      "SECURITY_ACTIVESESSIONSALLOWED" => :security_activesessionsallowed,
      "SECURITY_ADMINISTRATORPASSWORDEXPIRY" => :security_administratorpasswordexpiry,
      "SECURITY_ADMINISTRATORPASSWORDMINIMUMLENGTH" => :security_administratorpasswordminimumlength,
      "SECURITY_ADMINISTRATORPASSWORDREQUIRECASE" => :security_administratorpasswordrequirecase,
      "SECURITY_ADMINISTRATORPASSWORDREQUIREMIX" => :security_administratorpasswordrequiremix,
      "SECURITY_ADMINISTRATORPASSWORDREQUIRESPECIAL" => :security_administratorpasswordrequirespecial,
      "SECURITY_MINUTESTOTIMEOUT" => :security_minutestotimeout,
      "SECURITY_SIGNINATTEMPTSALLOWED" => :security_signinattemptsallowed,
      "SMTP_BOUNCEEMAIL" => :smtp_bounceemail,
      "SMTP_FROMEMAIL" => :smtp_fromemail,
      "SMTP_PASSWORD" => :smtp_password,
      "SMTP_REQUIRESAUTHENTICATION" => :smtp_requiresauthentication,
      "SMTP_URL" => :smtp_url,
      "SMTP_USERNAME" => :smtp_username,
      "STATE_DSMWASUPGRADEDFROMPRE75" => :state_dsmwasupgradedfrompre75,
      "WHOIS_IP" => :whois_ip
  }

  # Security Profile Recommendation Engine configured state enumeration.
  EnumTimeFilterType = {
      "LAST_HOUR" => :last_hour,
      "LAST_24_HOURS" => :last_24_hours,
      "LAST_7_DAYS" => :last_7_days,
      "CUSTOM_RANGE" => :custom_range,
      "SPECIFIC_TIME" => :specificTime
  }

  # General filter operator enumeration. Used when filtering retrieved events by event ID that are greater than, less
  # than, or equal to.
  EnumOperator = {
      "GREATER_THAN" => :greater_than,
      "LESS_THAN" => :less_than,
      "EQUAL" => :equal
  }

  # The origin of an event enumeration.
  EnumEventOrigin = {
      "UNKNOWN" => :unknown,
      "AGENT" => :agent,
      "GUESTAGENT" => :guestagent,
      "APPLIANCEAGENT" => :applianceagent,
      "MANAGER" => :manager
  }

  # Malware type enumeration.
  EnumMalwareType = {
      "GENERAL" => :general,
      "SPYWARE" => :spyware
  }

  # Malware scan type enumeration.
  EnumAntiMalwareScanType = {
      "REALTIME" => :realtime,
      "MANUAL" => :manual,
      "SCHEDULED" => :scheduled
  }

  # Cloud Object Types.
  EnumCloudObjectType = {
      "AMAZON_VM" => :amazon_vm,
      "VCLOUD_VM" => :vcloud_vm
  }

end