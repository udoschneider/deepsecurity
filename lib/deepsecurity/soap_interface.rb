# @author Udo Schneider <Udo.Schneider@homeaddress.de>

module DeepSecurity

  class SOAPInterface < SavonHelper::SOAPInterface

    attr_accessor :manager

    # Obtain a new wrapper around the DeepSecurity Manager SOAP API.
    def initialize(hostname, port=4119, logger, log_level)
      @hostname = hostname
      @port = port
      super("https://#{hostname}:#{port}/webservice/Manager?WSDL",
            logger,
            log_level,
            {:convert_request_keys_to => :none, # or one of [:lower_camelcase, :upcase, :none]
             :ssl_verify_mode => :none})

    end

    # @!group Request Helper

    # Send an authenticated WebUI Request to the Server for URL +url and return the response body
    def send_authenticated_http_get(path, sID)
      logger.debug { "#{self.class}\##{__method__}(#{path.inspect})" }
      url = "https://#{@hostname}:#{@port}#{path}"
      request = HTTPI::Request.new(url)
      request.auth.ssl.verify_mode = :none
      request.headers = {
          "Cookie" => "sID=#{sID}"
      }
      request.gzip
      response = HTTPI.get request
      response.body
    end

    # Send an authenticated WebUI Request to the Server for URL +url and return the response body
    def send_authenticated_http_post(path, body, sID)
      logger.debug { "#{self.class}\##{__method__}(#{path.inspect})" }
      url = "https://#{@hostname}:#{@port}#{path}"
      request = HTTPI::Request.new(url)
      request.auth.ssl.verify_mode = :none
      request.headers = {
          "Cookie" => "sID=#{sID}",
          "Content-Type" => "application/x-www-form-urlencoded"
      }
      request.gzip
      request.body = body
      response = HTTPI.post request
      response.body
    end

    # @!endgroup

  end

end
