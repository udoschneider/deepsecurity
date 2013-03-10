module Dsc


  def self.output_from_option(option)
    unless option == '--'
      output = File.open(option, 'w')
    else
      output = STDOUT
    end

    yield output

    output.close() unless option == '--'
  end

  def self.debug_level_from_option(option)
    return nil if option.blank?
    return option.to_sym if (DeepSecurity::LOG_MAPPING.keys.include?(option.to_sym))
    :debug
  end

  def self.dsm_connect(hostname, port, tenat, username, password, debug)

    begin
      dsm = DeepSecurity::Manager.server(hostname, port, debug)
      dsm.connect(tenat, username, password)
      yield dsm
    rescue DeepSecurity::AuthenticationFailedException => e
      puts "Authentication failed! #{e.message}"
    ensure
      dsm.disconnect()
    end

  end

  def self.print_api_version(hostname, port, tenat, username, password, output, debug)
    dsm_connect(hostname, port, tenat, username, password, debug) do |dsm|
      output.puts dsm.api_version()
    end
  end

  def self.print_manager_time(hostname, port, tenat, username, password, output, debug)
    dsm_connect(hostname, port, tenat, username, password, debug) do |dsm|
      output.puts dsm.manager_time()
    end
  end

end