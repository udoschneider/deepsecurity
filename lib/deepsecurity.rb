require "curb"

require "time"
require "cache"
require "active_support/core_ext"

require "deepsecurity/version"

require "deepsecurity/enums"

require "deepsecurity/exceptions/soap_exception"
require "deepsecurity/exceptions/authentication_failed_exception"
require "deepsecurity/exceptions/authentication_required_exception"

require "deepsecurity/manager"
require "deepsecurity/screenscraping"

require "deepsecurity/objects/dsm_object"

require "deepsecurity/objects/host_filter"
require "deepsecurity/objects/time_filter"
require "deepsecurity/objects/id_filter"

require "deepsecurity/objects/dpi_rule"
require "deepsecurity/objects/protocol_icmp"
require "deepsecurity/objects/protocol_port_based"
require "deepsecurity/objects/application_type"
require "deepsecurity/objects/host_group"
require "deepsecurity/objects/host"
require "deepsecurity/objects/host_detail"
require "deepsecurity/objects/security_profile"
require "deepsecurity/objects/system_event"
require "deepsecurity/objects/anti_malware_spyware_item"
require "deepsecurity/objects/anti_malware_event"


require "deepsecurity/objects/private/vulnerability"


Savon.configure do |config|
  config.log = false # disable logging
                     # config.log_level = :info # changing the log level
                     # config.logger = Rails.logger  # using the Rails logger
end

HTTPI.log = false # disable logging
                  # HTTPI.logger    = MyLogger  # change the logger
                  # HTTPI.log_level = :info     # change the log level

HTTPI.adapter= :net_http # :httpclient, :curb, :net_http


# This modules encapsulates the DeepSecurity WebAPI with a Ruby Wrapper

def retryable(options = {}, &block)
  opts = {:tries => 1, :on => Exception}.merge(options)

  retry_exception, retries = opts[:on], opts[:tries]

  begin
    return yield
  rescue retry_exception
    retry if (retries -= 1) > 0
  end

  yield
end