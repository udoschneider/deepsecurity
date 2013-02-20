# @author Udo Schneider <Udo.Schneider@homeaddress.de>

# require "curb"

# require "time"
# require "cache"
# require "active_support/core_ext"

require "deepsecurity/version"

require "deepsecurity/enums"

require "deepsecurity/exceptions/soap_exception"
require "deepsecurity/exceptions/authentication_failed_exception"
require "deepsecurity/exceptions/authentication_required_exception"
require "deepsecurity/exceptions/missing_type_mapping_exception"

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
require "deepsecurity/transport_objects/host_detail"
require "deepsecurity/transport_objects/security_profile"
require "deepsecurity/transport_objects/system_event"
require "deepsecurity/transport_objects/anti_malware_spyware_item"
require "deepsecurity/transport_objects/anti_malware_event"


require "deepsecurity/transport_objects/private/vulnerability"


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

module DeepSecurity

  def self.logger
    if @logger.nil?
      @logger ||= Logger.new(STDOUT)
      @logger.level = Logger::INFO
    end
    @logger
  end

end