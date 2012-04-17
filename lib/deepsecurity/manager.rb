require "savon"
require "httpi"
require "colorize"

module DeepSecurity

# This class represents the DeepSecurity Manager. It's the entry point for all further actions
  class Manager

    attr_reader :session_id

    private

    # Obtain a new wrapper around the DeepSecurity Manager SOAP API.
    # Please note that the port is always assumed to be +4119+!
    def initialize(hostname)
      @hostname = hostname
      super()
      @client = Savon::Client.new do
        wsdl.document = "https://#{hostname}:4119/webservice/Manager?WSDL"
        http.auth.ssl.verify_mode=:none
      end
    end

    # Send a Request to the SOAP API for method +method_name+ with the data in +soap_body+ and unwrap the response
    def send_request(method_name, soap_body = {}) #:doc:
      retryable(:tries => 5, :on => Errno::ECONNRESET) do
        puts "#{self.class}\##{__method__}(#{method_name.inspect}, #{soap_body.inspect})".colorize(:blue)
        begin
          response = @client.request method_name do
            soap.body = soap_body
          end
          return response.to_hash[(method_name+"_response").to_sym][(method_name+"_return").to_sym]
        rescue Savon::Error => e
          raise SOAPException, e.message
        end
      end
    end

    # Send an authenticated Request to the SOAP API for method +method_name+ with the data in +soap_body+ and unwrap the response
    def send_authenticated_request(method_name, soap_body={})
      # puts "#{self.class}##{__method__}(#{method_name}, #{soap_body.to_s})"
      raise AuthenticationRequiredException if !authenticated?
      authenticated_soap_body = soap_body
      soap_body[:sid] = @session_id
      send_request(method_name, soap_body)
    end


    public

    # Send an authenticated Request to the Server for URL +url and return the response body
    def send_authenticated_http_get(path)
      puts "#{self.class}\##{__method__}(#{path.inspect})".colorize(:blue)
      url = "https://#{@hostname}:4119#{path}"
      request = HTTPI::Request.new(url)
      request.auth.ssl.verify_mode = :none
      request.headers = {
          "Cookie" => "sID=#{@session_id}"
      }
      request.gzip
      response = HTTPI.get request
      response.body
    end

    def request_object(method_name, object_class, soap_body={})
      object_class.from_hash(self, send_authenticated_request(method_name, soap_body))
    end

    def request_array(method_name, object_class, soap_body={})
      send_authenticated_request(method_name, soap_body).map { |each| object_class.from_hash(self, each) }
    end

    def client
      @client
    end

    def to_s
      "#{self.class.to_s}"
    end

    def cache
      @cache ||= Cache.new(nil, nil, 10000, 5*60)
    end

    # Retrieves the Manager Web Service API version. Not the same as the Manager version.
    # RETURNS  The Web Service API version.
    def api_version
      send_request("get_api_version").to_i
    end

    # Retrieve the Manager Web Service API version. Not the same as the Manager version.
    # RETURNS: Manager time.
    def manager_time
      send_request("get_manager_time")
    end

    # Authenticate to the DSM with the given credentials.
    def authenticate(username, password)
      begin
        @session_id = send_request("authenticate", {:username => username, :password => password}).to_s
      rescue Errno::ECONNABORTED, DeepSecurity::SOAPException => e
        raise AuthenticationFailedException, e.message
      end
    end

    # Check if the session has been authenticated.
    def authenticated?
      !@session_id.nil?
    end

    # Ends an authenticated user session. The Web Service client should end the authentication session in all exit cases.
    def end_session
      if @session_id
        send_authenticated_request("end_session")
        @session_id = nil
      end
    end

  end
end