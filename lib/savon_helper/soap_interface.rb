# @author Udo Schneider <Udo.Schneider@homeaddress.de>

module SavonHelper

  class SOAPInterface

    def initialize(wsdl_url, logger = Logger.new(STDERR), log_level = nil, options = {})
      HTTPI.log = (!log_level.nil?)
      HTTPI.logger = logger
      HTTPI.log_level = log_level

      @client = Savon.client(options.merge({:wsdl => wsdl_url,
                                            :logger => logger,
                                            :log_level => log_level,
                                            :log => (!log_level.nil?),
                                            :ssl_verify_mode => :none}))
      @logger = logger
    end

    def logger
      @logger
    end

    # @!group Request Helper

    # Send a Request to the SOAP API for method with arguments and unwrap the response
    # @param method [Symbol] The SOAP method to call.
    # @param arguments [Hash] The method arguments
    # @return [Hash] The result hash.
    def send_soap(method, arguments = {})
      logger.debug { "#{self.class}\##{__method__}(#{method.inspect}, #{arguments.inspect})" }
      retryable(:tries => 5, :on => Errno::ECONNRESET) do
        response = @client.call method, :message => arguments
        return response.to_hash[(method.to_s+"_response").to_sym][(method.to_s+"_return").to_sym]
      end
    end

    # Helper Method deserializing the SOAP response into an object
    # @param method_name [Symbol] The SOAP method to call.
    # @param object_class [MappingObject] The class to typecast the result to.
    # @param arguments [Hash] The method arguments
    # @return [object_class] The object filled from the response.
    def request_object(method_name, object_class, arguments={})
      data = send_soap(method_name, arguments)
      # ObjectMapping.to_native(object_class, data, self)
      object_class.from_savon(data, self)
      # raise "Halt"
    end

    # Helper Method deserializing the SOAP response into an array of objects.
    # @param method_name [Symbol] The SOAP method to call.
    # @param object_class [MappingObject] The element class to typecast the result elements to.
    # @param collection_name [Symbol] The name of the reply parameter.
    # @param arguments [Hash] The method arguments
    # @return [Array<object_class>] The object filled from the response.
    def request_array(method_name, object_class, collection_name = nil, arguments={})
      data = send_soap(method_name, arguments)
      data = data[collection_name] unless collection_name.blank?
      ArrayMapping.to_native(ObjectMapping.new(object_class), data, self)
      # SavonHelper::ArrayMapping.new(SavonHelper::ObjectMapping.new(object_class)).from_savon_data(data)
    end

    # @!endgroup

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

  end

end