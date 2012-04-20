require "savon"
require "httpi"
require "colorize"
require "logger"

module DeepSecurity

# This class represents the DeepSecurity Manager. It's the entry point for all further actions
  class Manager

    attr_reader :session_id, :logger

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
        logger.debug { "#{self.class}\##{__method__}(#{method_name.inspect}, #{soap_body.inspect})" }
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
      logger.debug { "#{self.class}##{__method__}(#{method_name}, #{soap_body.to_s})" }
      raise AuthenticationRequiredException if !authenticated?
      authenticated_soap_body = soap_body
      soap_body[:sid] = @session_id
      send_request(method_name, soap_body)
    end


    public

    def logger
      if @logger.nil?
        @logger ||= Logger.new(STDOUT)
        @logger.level = Logger::INFO
      end
      @logger
    end

    # Send an authenticated Request to the Server for URL +url and return the response body
    def send_authenticated_http_get(path)
      logger.debug { "#{self.class}\##{__method__}(#{path.inspect})" }
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

    # Send an authenticated Request to the Server for URL +url and return the response body
    def send_authenticated_http_post(path, body)
      logger.debug { "#{self.class}\##{__method__}(#{path.inspect})" }
      url = "https://#{@hostname}:4119#{path}"
      request = HTTPI::Request.new(url)
      request.auth.ssl.verify_mode = :none
      request.headers = {
          "Cookie" => "sID=#{@session_id}",
          "Content-Type" => "application/x-www-form-urlencoded"
      }
      request.gzip
      request.body = body
      response = HTTPI.post request
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

    def clean_html_string(string)
      string.
          inner_text.
          gsub(/\s+/, " ").
          strip
    end

    def symbolize_header(string)
      string.
          gsub(/::/, '/').
          gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').
          gsub(/([a-z\d])([A-Z])/, '\1_\2').
          gsub(/\s+/, "_").
          tr("-", "_").
          downcase.
          to_sym
    end

    def post_setting(action, parameters, settings)

      parameters_string = URI.escape(parameters.map { |key, value| "#{key}=#{value}" }.join("&"))
      path = "/#{action}?#{parameters_string}"
      body = send_authenticated_http_get(path)

      doc = Hpricot(body)
      form_values = {}
      doc.search("input").each do |input|
        type = input["type"]
        unless type == "button" || type == "submit"
          form_values[input['name']] = input['value'] unless input['name'].blank?
        end
      end

      form_values = form_values.merge(settings)

      action = doc.search("form#mainForm").first["action"]
      parameters_string = URI.encode_www_form(form_values)
      path = "/#{action}"
      send_authenticated_http_post(path, parameters_string)


    end

    def show_rules(host_id, type)
      "GET /PayloadFilter2s.screen?hostID=2&noSearch=true&hideStandardHeader=true HTTP/1.1"
      post_setting("PayloadFilter2s.screen", {"hostID" => host_id, "noSearch" => true, "hideStandardHeader" => true}, {"command" => "CHANGEASSIGNFILTER", "arguments" => type})
    end


    def enable_columns

      action = "AddRemoveColumns.screen"
      parameters = {
          :screenSettingKey => "payloadFilter2s.",
          :columnDisplayNames => [
              # "payloadFilter2s.column.summaryDescription",
              # "payloadFilter2s.column.summaryOriginallyIssued",
              # "payloadFilter2s.column.schedule",
              # "payloadFilter2s.column.disableLog",
              # "payloadFilter2s.column.logPacketDrop",
              # "payloadFilter2s.column.logPacketModify",
              # "payloadFilter2s.column.includePacketData",
              # "payloadFilter2s.column.ruleContext",
              # "payloadFilter2s.column.alert",
              # "payloadFilter2s.column.summaryRecommendable",
              # "payloadFilter2s.column.summaryMinimumAgentVersion",
              "payloadFilter2s.column.cve",
              "payloadFilter2s.column.secunia",
              "payloadFilter2s.column.bugtraq",
              "payloadFilter2s.column.ms"
          ].join(","),
          :columnAdminSettingNames => [
              # "summaryDescription",
              # "summaryOriginallyIssued",
              # "summarySchedule",
              # "disableLogIcon",
              # "logPacketDropIcon",
              # "logPacketModifyIcon",
              # "includePacketDataIcon",
              # "summaryRuleContext",
              # "alertIcon",
              # "summaryRecommendable",
              # "summaryMinimumAgentVersion",
              "summaryCVE",
              "summarySECUNIA",
              "summaryBUGTRAQ",
              "summaryMS"
          ].join(",")
      }
      settings = {
          "summaryCVE" => true,
          "summarySECUNIA" => true,
          "summaryBUGTRAQ" => true,
          "summaryMS" => true
      }

      post_setting(action, parameters, settings)

    end

    def payload_filters(optional_parameters = {})

      num_rules = nil
      rules = []
      column_mapping = Hash.new()
      while num_rules.nil? || rules.count < num_rules

        mainTableViewState = ["",
                              "controlCheck,after=[NONE]",
                              "icon,after=controlCheck",
                              "summaryConnectionType,after=icon",
                              "fullName,after=summaryConnectionType",
                              "summaryPriority,after=fullName",
                              "summarySeverityHTML,after=summaryPriority",
                              "summaryMode,after=summarySeverityHTML",
                              "summaryType,after=summaryMode",
                              "summaryCVE,after=summaryType",
                              "summarySECUNIA,after=summaryCVE",
                              "summaryBUGTRAQ,after=summarySECUNIA",
                              "summaryMS,after=summaryBUGTRAQ",
                              "summaryCvssScore,after=summaryMS",
                              "summaryIssued,after=summaryCvssScore"]

        parameters = {
            # :mainTable_viewstate => URI.escape(mainTableViewState.join('|')),
            :paging_offset => rules.count
        }
        parameters_string = (parameters.merge(optional_parameters).map { |k, v| "#{k}=#{v}" }).join("&")

        path = "/PayloadFilter2s.screen?#{parameters_string}"
        body = send_authenticated_http_get(path)
        doc = Hpricot(body)

        if num_rules.nil?
          num_rules = doc.search("td.paging_text").inner_text.split(/\s+/)[-1]
          if !num_rules.nil?
            num_rules = num_rules.scan(/\d/).join.to_i
          else
            num_rules = 0
          end
          # puts "num_rules #{num_rules}"
        end


        if column_mapping.empty?
          doc.
              search("#mainTable_header_table td:not(.datatable_resizer)").
              map { |each| clean_html_string(each)[0..-2] }.
              each_with_index { |each, index| column_mapping[each]=index unless each.blank? }
        end

        doc.search("#mainTable_rows_table tr") do |row|
          column_cells = row.
              search("td").
              map { |each| clean_html_string(each) }
          rule = Hash.new()
          column_mapping.each do |k, v|
            rule[symbolize_header(k)]=column_cells[v]
          end
          rules.push(rule)
        end
      end
      rules


    end

  end
end