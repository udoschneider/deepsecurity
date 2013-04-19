# @author Udo Schneider <Udo.Schneider@homeaddress.de>

require "logger"

require "json"

require "savon_helper"

require "deepsecurity/version"

require "deepsecurity/enums"

require "deepsecurity/exceptions/authentication_failed_exception"
require "deepsecurity/exceptions/authentication_required_exception"

require "deepsecurity/soap_interface"

require "deepsecurity/manager"
require "deepsecurity/screenscraping"

require "deepsecurity/transport_object"

require "deepsecurity/transport_objects/host_filter"
require "deepsecurity/transport_objects/time_filter"
require "deepsecurity/transport_objects/id_filter"

require "deepsecurity/transport_objects/dpi_rule"
require "deepsecurity/transport_objects/protocol_icmp"
require "deepsecurity/transport_objects/protocol_port_based"
require "deepsecurity/transport_objects/application_type"
require "deepsecurity/transport_objects/host_group"
require "deepsecurity/transport_objects/host"
require "deepsecurity/transport_objects/host_interface"
require "deepsecurity/transport_objects/host_detail"
require "deepsecurity/transport_objects/security_profile"
require "deepsecurity/transport_objects/system_event"
require "deepsecurity/transport_objects/anti_malware_spyware_item"
require "deepsecurity/transport_objects/anti_malware_event"


require "deepsecurity/transport_objects/private/vulnerability"

module DeepSecurity

  def self.dsm
    Manager.current
  end

  LOG_MAPPING = {
      :debug => Logger::DEBUG,
      :info => Logger::INFO,
      :warn => Logger::WARN,
      :error => Logger::ERROR,
      :fatal => Logger::FATAL
  }

end
