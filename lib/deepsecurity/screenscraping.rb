# require "hpricot"

module DeepSecurity
  class Manager

    private

    # Helper Method: Clean up any HTML remnants (e.g. &nbsp;)
    def clean_html_string(string)
      string.
          inner_text.
          gsub(/\s+/, " ").
          strip
    end

    # Helper Method: Convert header string to camel cased symbol
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

    # Fetch the given +action+ with +parameters+. Post the result with settings changed according to +settings+
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

    # Enable display of DPI rules "type" for a given host
    def payload_filters2_show_rules(host_id, type)
      post_setting("PayloadFilter2s.screen", {
          "hostID" => host_id,
          "noSearch" => true,
          "hideStandardHeader" => true
      }, {
                       "command" => "CHANGEASSIGNFILTER",
                       "arguments" => type}
      )
    end

    # Enable vulnerability columns in DPI rules display
    def payload_filters2_enable_vulnerability_columns

      action = "AddRemoveColumns.screen"
      parameters = {
          :screenSettingKey => "payloadFilter2s.",
          :columnDisplayNames => %w[ payloadFilter2s.column.cve payloadFilter2s.column.secunia payloadFilter2s.column.bugtraq payloadFilter2s.column.ms ].join(","),
          :columnAdminSettingNames => %w[ summaryCVE summarySECUNIA summaryBUGTRAQ summaryMS ].join(",")
      }
      settings = {
          "summaryCVE" => true,
          "summarySECUNIA" => true,
          "summaryBUGTRAQ" => true,
          "summaryMS" => true
      }

      post_setting(action, parameters, settings)

    end

    # Retrieve DPI rules
    def payload_filters2(optional_parameters = {})

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