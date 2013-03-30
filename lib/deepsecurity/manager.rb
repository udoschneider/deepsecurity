# @author Udo Schneider <Udo.Schneider@homeaddress.de>

module DeepSecurity

  # This class represents the DeepSecurity Manager. It's the entry point for all further actions
  class Manager < SavonHelper::CachingObject

    # @!group High-Level SOAP Wrapper

    # Set connection parameters
    # @param hostname [String] host to connect to
    # @param port [Integer] port to connect to
    # @param log_level [LOG_MAPPING] Log Level
    def self.server(hostname, port=4119, log_level=nil, logger = nil)
      default_logger = Logger.new(STDOUT)
      default_logger.level = LOG_MAPPING[log_level] || Logger::INFO
      self.new(DeepSecurity::SOAPInterface.new(hostname, port, logger || default_logger, log_level))
    end

    # @param interface [DeepSecurity::SOAPInterface] The initialized interface to direct further calls to.
    def initialize(interface)
      @interface = interface
      @interface.manager = self
    end


    # Authenticates a user within the given tenant, and returns a session ID for use when calling other methods of Manager.
    # When no longer required, the session should be terminated by calling disconnect.
    # @param tenant [String]
    # @param username [String]
    # @param password [String]
    # @return [Manager] The current manager
    def connect(tenant, username, password)
      @sID = (tenant.blank? ? interface.authenticate(username, password) : interface.authenticateTenant(tenant, username, password)).to_s
      self
    rescue Savon::SOAPFault => error
      fault = error.to_hash[:fault]
      message = fault[:faultstring].to_s
      message = fault[:detail][:exception_name].to_s if message.blank?
      raise AuthenticationFailedException.new("(#{message})")
    end

    # Ends an authenticated user session. The Web Service client should end the authentication session in all exit cases.
    # @return [void]
    def disconnect
      interface.endSession() if authenticated?
    end

    # Retrieves the Manager Web Service API version. Not the same as the Manager version.
    # @return [Integer] The Web Service API version.
    def api_version
      interface.getApiVersion().to_i
    end

    # Retrieve the Manager Web Service API version. Not the same as the Manager version.
    # @return [Time] Manager time as a language localized object.
    def manager_time
      Time.parse(interface.getManagerTime())
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

    def interface
      @interface
    end

  end

  class SOAPInterface

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
      send_soap(:get_api_version)
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
      send_soap(:get_manager_time)
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
      send_soap(:authenticate, {:username => username, :password => password})
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
    def authenticateTenant(tenantName, username, password)
      send_soap(:authenticate_tenant, {:tenantName => tenantName, :username => username, :password => password})
    end

    # Ends an authenticated user session. The Web Service client should end the authentication session in all exit cases.
    #
    # SYNTAX
    #   void endSession(String sID)
    #
    # PARAMETERS
    #   sID Authentication session identifier ID.
    # RETURNS
    def endSession(sID = manager.sID)
      send_soap(:end_session, :sID => sID)
    end

    # @!endgroup

  end

end