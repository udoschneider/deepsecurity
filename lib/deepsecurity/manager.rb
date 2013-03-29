# @author Udo Schneider <Udo.Schneider@homeaddress.de>

require "savon"
require "cache"
# require "httpi"
require "logger"
# require "yaml"

module DeepSecurity

  LOG_MAPPING = {
      :debug => Logger::DEBUG,
      :info => Logger::INFO,
      :warn => Logger::WARN,
      :error => Logger::ERROR,
      :fatal => Logger::FATAL
  }

  # This class  represents the DeepSecurity Manager. It's the entry point for all further actions
  class Manager <DSObject

    @@current = nil

    def self.current
      @@current
    end

    def reset
      @@current = nil
    end

    # Obtain a new wrapper around the DeepSecurity Manager SOAP API.
    def initialize(hostname, port=4119, log_level)
      @hostname = hostname
      @port = port
      super()
      @client = Savon.client(:wsdl => "https://#{hostname}:#{port}/webservice/Manager?WSDL",
                             :convert_request_keys_to => :none, # or one of [:lower_camelcase, :upcase, :none]
                             :ssl_verify_mode => :none,
                             :logger => logger,
                             :log_level => log_level,
                             :log => (!log_level.nil?))
    end

    # @!group Request Helper

    # Send an authenticated WebUI Request to the Server for URL +url and return the response body
    def send_authenticated_http_get(path)
      logger.debug { "#{self.class}\##{__method__}(#{path.inspect})" }
      url = "https://#{@hostname}:#{@port}#{path}"
      request = HTTPI::Request.new(url)
      request.auth.ssl.verify_mode = :none
      request.headers = {
          "Cookie" => "sID=#{@sID}"
      }
      request.gzip
      response = HTTPI.get request
      response.body
    end

    # Send an authenticated WebUI Request to the Server for URL +url and return the response body
    def send_authenticated_http_post(path, body)
      logger.debug { "#{self.class}\##{__method__}(#{path.inspect})" }
      url = "https://#{@hostname}:#{@port}#{path}"
      request = HTTPI::Request.new(url)
      request.auth.ssl.verify_mode = :none
      request.headers = {
          "Cookie" => "sID=#{@sID}",
          "Content-Type" => "application/x-www-form-urlencoded"
      }
      request.gzip
      request.body = body
      response = HTTPI.post request
      response.body
    end

    # @!endgroup

    # @!group Caching

    def cache
      @cache ||= Cache.new(nil, nil, 10000, 5*60)
    end

    # @!endgroup

    public

    # @!group High-Level SOAP Wrapper

    # Retrieves the Manager Web Service API version. Not the same as the Manager version.
    # @return [Integer] The Web Service API version.
    def api_version
      dsm.getApiVersion()
    end

    # Retrieve the Manager Web Service API version. Not the same as the Manager version.
    # @return [Time] Manager time as a language localized object.
    def manager_time
      dsm.getManagerTime()
    end

    # Set connection parameters
    # @param hostname [String] host to connect to
    # @param port [Integer] port to connect to
    # @param log_level [LOG_MAPPING] Log Level
    def self.server(hostname, port=4119, log_level=nil)
      dsm = self.new(hostname, port, log_level)
      dsm.logger.level = LOG_MAPPING[log_level] unless log_level.nil?
      @@current = dsm
    end

    # Authenticates a user within the given tenant, and returns a session ID for use when calling other methods of Manager. When no longer required, the session should be terminated by calling endSession.
    # @param tenant [String]
    # @param username [String]
    # @param password [String]
    # @return [Manager] The current manager
    def connect(tenant, username, password)
      @sID = tenant.blank? ? authenticate(username, password) : authenticate_tenant(tenant, username, password)
      dsm
    rescue Savon::SOAPFault => error
      raise AuthenticationFailedException.new(error.to_hash[:fault][:faultstring].to_s)
    end

    # Ends an authenticated user session. The Web Service client should end the authentication session in all exit cases.
    # @return [void]
    def disconnect
      dsm.end_session() if authenticated?
      dsm.reset
      nil
    end

    # @!endgroup

    # @!group Low-Level SOAP Wrapper

    # Retrieves the Manager Web Service API version. Not the same as the Manager version.
    #
    # SYNTAX
    #   int getApiVersion()
    #
    # PARAMETERS
    #
    # RETURNS
    #   The Web Service API version.
    def getApiVersion
      send_soap(:get_api_version).to_i
    end

    # Retrieve the Manager Web Service API version. Not the same as the Manager version.
    #
    # SYNTAX
    #   getManagerTime()
    #
    # PARAMETERS
    #
    # RETURNS
    #   Manager time as a language localized object. For example, a Java client would return a Calendar object, and a C# client would return a DataTime object.
    def getManagerTime
      Time.parse(send_soap(:get_manager_time))
    end

    # Authenticates a user for and returns a session ID for use when calling other Web Service methods.
    #
    # SYNTAX
    #   String authenticate(String username, String password)
    #
    # PARAMETERS
    #   username Account username.
    #   password Account password.
    #
    # RETURNS
    #   Authenticated user session ID.
    def authenticate(username, password)
      send_soap(:authenticate, {:username => username, :password => password}).to_s
    end

    # Authenticates a user within the given tenant, and returns a session ID for use when calling other methods of Manager. When no longer required, the session should be terminated by calling endSession.
    #
    # SYNTAX
    #   String authenticateTenant(String tenantName, String username, String password)
    #
    # PARAMETERS
    #   tenantName Tenant Name.
    #   username Account username.
    #   password Account password.
    #
    # RETURNS
    #   Authenticated user session ID.
    def authenticate_tenant(tenantName, username, password)
      send_soap(:authenticate_tenant, {:tenantName => tenantName, :username => username, :password => password}).to_s
    end

    # Ends an authenticated user session. The Web Service client should end the authentication session in all exit cases.
    #
    # SYNTAX
    #   void endSession(String sID)
    #
    # PARAMETERS
    #   sID Authentication session identifier ID.
    # RETURNS
    def end_session(sID = dsm.sID)
      send_soap(:end_session, :sID => sID)
    end

    # @!endgroup

    # Check if the session has been authenticated.
    def authenticated?
      !@sID.nil?
    end

    def sID
      raise DeepSecurity::AuthenticationRequiredException unless authenticated?
      @sID
    end

    def client
      @client
    end

  end
end