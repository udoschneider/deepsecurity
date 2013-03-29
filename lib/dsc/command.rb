# @author Udo Schneider <Udo.Schneider@homeaddress.de>
require "progressbar"
require "csv"

module Dsc

  # This class defines an superclass for all `dsc` commands. It defines several helper methods which either define
  # flags, options and commands or helpers to define them.
  # @abstract
  class Command

    # @abstract DeepSecurity object covered by this class.
    # @return [DeepSecurity::TransportObject]
    def self.transport_class
      nil
    end

    # @!group Helper methods

    # Transport class name without namespace
    # @return [String] Transport class name without namespace
    def self.transport_class_name
      class_name = transport_class.name.split('::').last || ''
    end

    #  Human readable transport class name without namespace
    # @return [String] Human readable transport class name without namespace
    def self.transport_class_string
      transport_class_name.split(/(?=[A-Z])/).join(" ")
    end

    # Class name without namespace as command_context symbol
    # @return [Symbol] Class name without namespace as command_context symbol
    def self.command_symbol
      transport_class_name.split(/(?=[A-Z])/).join("_").downcase.to_sym
    end

    # The schema of the transport class
    # @return [Hash<Symbol => SavonHelper::TypeMapping]
    def self.schema
      transport_class.mappings
    end

    # @!endgroup

    # @param [Hash] global_options Global options passed to the `dsc` command_context.
    # @option global_options [String] :manager The hostname of the DeepSecurity Manager.
    # @option global_options [String] :port The TCP port to use.
    # @option global_options [String, nil] :tenant The tenant name or nil.
    # @option global_options [String] :username The username.
    # @option global_options [String] :password The password.
    # @option global_options [Boolean] :P Show progessbar?
    # @option global_options [String, nil] :debug The debug level.
    # @option global_options [String] :outfile The outfile.
    def initialize(global_options)
      @hostname = global_options[:manager]
      @port = global_options[:port].to_i
      @tenant = global_options[:tenant]
      @username = global_options[:username]
      @password = global_options[:password]
      @show_progress_bar = global_options[:P]
      @debug_level = parse_debug_level(global_options[:debug])
      @output = global_options[:outfile]
    end

    # @!group Helper methods

    # Provide an open output  while executing the block.
    # @yieldparam output [IO] Opened IO
    # @yield [output] Gives the output to the block
    # @return [void]
    def output
      unless @output == '--'
        output = File.open(option, 'w')
      else
        output = STDOUT
      end
      yield output
      output.close() unless @output == '--'
    end

    # Provides a connection to the DeepSecurity Manager  while executing the block.
    # @yieldparam manager [DeepSecurity::Manager] DeepSecurity Manager
    # @yield [manager] Gives the manager to the block
    # @return [void]
    def connect
      manager = DeepSecurity::Manager.server(@hostname, @port, @debug_level)
      yield manager
    end

    # Provides an authenticated connection to the DeepSecurity Manager  while executing the block.
    # @yieldparam manager [DeepSecurity::Manager] DeepSecurity Manager
    # @yield [manager] Gives the manager to the block
    # @return [void]
    def authenticate
      connect do |dsm|
        begin
          dsm.connect(@tenant, @username, @password)
          yield dsm
        rescue DeepSecurity::AuthenticationFailedException => e
          puts "Authentication failed! #{e.message}"
        ensure
          dsm.disconnect()
        end
      end
    end

    # @!endgroup

    # @!group Misc global flags/options definitions

    # Define flags
    # @return [void]
    def self.define_global_flags(command_context)
      define_debug_flag(command_context)
      define_manager_flag(command_context)
      define_port_flag(command_context)
      define_tenant_flag(command_context)
      define_username_flag(command_context)
      define_password_flag(command_context)
      define_outfile_flag(command_context)
      define_progress_bar_option(command_context)
    end

    # Define manager hostname flag
    # @param command_context [CLI::App] The current context of the command.
    # @return [void]
    def self.define_manager_flag(command_context)
      command_context.flag [:m, :manager],
                           :desc => 'Deep Security Manager Host',
                           :arg_name => 'hostname'
    end

    # Define manager TCP Port flag
    # @param command_context [CLI::App] The current context of the command.
    # @return [void]
    def self.define_port_flag(command_context)
      command_context.flag [:port],
                           :desc => 'Webservice Port',
                           :arg_name => 'port',
                           :default_value => '4119'
    end

    # Define tenant flag
    # @param command_context [CLI::App] The current context of the command.
    # @return [void]
    def self.define_tenant_flag(command_context)
      command_context.flag [:t, :tenant],
                           :desc => 'Tenat Name',
                           :arg_name => 'tenat',
                           :default_value => ''
    end

    # Define username flag
    # @param command_context [CLI::App] The current context of the command.
    # @return [void]
    def self.define_username_flag(command_context)
      command_context.flag [:u, :username],
                           :desc => 'Username',
                           :arg_name => 'username',
                           :default_value => 'MasterAdmin'
    end

    # Define password flag
    # @param command_context [CLI::App] The current context of the command.
    # @return [void]
    def self.define_password_flag(command_context)
      command_context.flag [:p, :password],
                           :desc => 'Password',
                           :arg_name => 'password'
    end

    # Define outfile flag
    # @param command_context [CLI::App] The current context of the command.
    # @return [void]
    def self.define_outfile_flag(command_context)
      command_context.flag [:o, :outfile],
                           :desc => 'Output filename',
                           :default_value => '--'
    end

    # Define outfile flag
    # @param command_context [CLI::App] The current context of the command.
    # @return [void]
    def self.define_outfile_flag(command_context)
      command_context.flag [:o, :outfile],
                           :desc => 'Output filename',
                           :default_value => '--'
    end

    # Define progress_bar option
    # @param command_context [CLI::App] The current context of the command.
    # @return [void]
    def self.define_progress_bar_option(command_context)
      command_context.switch [:P, :'progress_bar'],
                             :desc => 'Show progressbar',
                             :default_value => false
    end

    # @!endgroup

    # @!group Debug Level flag

    # Valid debug levels
    # @return [Array<String>] Valid debug levels
    def self.valid_debug_levels
      DeepSecurity::LOG_MAPPING.keys
    end

    # String of debug levels for help string
    # @return [String] String of debug levels for help string
    def self.valid_debug_levels_string
      valid_debug_levels.join(", ")
    end

    # Parse debug level argument
    # @return [nil, DeepSecurity::LOG_MAPPING] Return parsed debug level
    def parse_debug_level(argument)
      return nil if argument.blank?
      return argument.to_sym if (DeepSecurity::LOG_MAPPING.keys.include?(argument.to_sym))
      :debug
    end

    # Define debug level flag
    # @return [void]
    def self.define_debug_flag(command_context)
      command_context.flag [:d, :debug],
                           :desc => "Enable client debug output. (One of #{Dsc::Command.valid_debug_levels_string})",
                           :arg_name => 'debug_level'
    end

    # @!endgroup

    # @!group Fields flag

    # Default fields if no argument is given
    # @note Needs to be overridden by subclass
    # @return [Array<String>] Default fields if no argument is given
    def self.default_fields
      []
    end

    # String of default fields for help string
    # @return [String]  String of default fields for help string
    def self.default_fields_string
      default_fields.join(",")
    end

    # Sorted list of available fields
    # @return [Array<String>] Sorted list of available fields
    def self.valid_fields
      transport_class.defined_attributes.sort
    end

    # String of available fields for help string
    # @return [String]  String of available fields for help string
    def self.valid_fields_string
      valid_fields.join(", ")
    end

    # Parse fields argument. Either split the string or read from file
    # @return [Array<String>] parse fields
    def parse_fields(fields_string_or_filename)
      filename = File.absolute_path(fields_string_or_filename_argument)
      if File.exists?(filename)
        fields_string = File.read(filename)
      else
        fields_string = fields_string_or_filename
      end
      fields = fields_string.split(",").map(&:strip)
      unknown_fields = fields.reject { |each| self.class.transport_class.has_attribute_chain(each) }
      raise "Unknown filename or field found (#{unknown_fields.join(', ')}) - known fields are: #{self.class.valid_fields.join(', ')}" unless unknown_fields.empty?
      fields
    end

    # Define fields flag
    # @return [void]
    def self.define_fields_flag(command_context)
      command_context.flag [:fields],
                           :desc => "A comma separated list of fields to display or a file containing those fields. (Available fields: #{self.valid_fields_string})",
                           :default_value => self.default_fields_string
    end

    # @!endgroup

    # @!group Time filter flag

    # Valid timefilter mapping (symbol to instance)
    # @return [Hash<Symbol => DeepSecurity::TimeFilter>] Valid timefilter mapping
    def self.valid_time_filters
      {
          :last_hour => DeepSecurity::TimeFilter.last_hour,
          :last_24_hours => DeepSecurity::TimeFilter.last_24_hours,
          :last_7_days => DeepSecurity::TimeFilter.last_7_days,
          :last_day => DeepSecurity::TimeFilter.last_day
      }
    end

    # Valid time filter string for help string
    # @return[String] Valid time filters
    def self.valid_time_filters_string
      valid_time_filters.keys.join(', ')
    end

    # Parse time_filter argument
    # @return [DeepSecurity::TimeFilter] Time filter
    def parse_time_filter(argument)
      filter = self.class.valid_time_filters[argument.to_sym]
      raise "Unknown time filter" if filter.nil?
      filter
    end

    # Define time_filter flag
    # @return [void]
    def self.define_time_filter_flag(command_context)
      command_context.flag [:time_filter],
                           :desc => "A filter specifying the time interval to query (One of #{self.valid_time_filters_string})",
                           :default_value => "last_day"
    end

    # @!endgroup

    # @!group Detail level flag

    # Valid detail levels
    # @return [Array<String>] Valid detail levels
    def self.valid_detail_levels
      DeepSecurity::EnumHostDetailLevel.keys()
    end

    # Valid detail levels for help string
    # @return [String]  Valid detail levels for help string
    def self.valid_detail_levels_string
      valid_detail_levels.join(", ")
    end

    # Parse detail_level argument
    # @return [EnumHostDetailLevel] Detail level
    def parse_detail_level(argument)
      detail_level = DeepSecurity::EnumHostDetailLevel[string.upcase.strip]
      raise "Unknown detail level filter" if detail_level.nil?
      detail_level
    end

    # Define detail_level flag
    # @return [void]
    def self.define_detail_level_flag(command_context)
      command_context.flag [:detail_level],
                           :desc => "A detail level specifiying the extent of data returned. (Available values: #{self.valid_detail_levels_string})",
                           :default_value => "low"
    end

    # @!endgroup

    # @!group Command definitions

    # @abstract Define all commands for this available for this (sub) command_context
    # @param command_context [CLI::App] The current context of the command.
    # @return [void]
    def self.define_commands(command_context)
    end

    # Define some simple commands.
    # @param command_context [CLI::App] The current context of the command.
    # @return [void]
    def self.define_misc_commands(command_context)
      self.define_api_version_command(command_context)
      self.define_manager_time_command(command_context)
    end

    # Define `api_version` command_context
    # @param command_context [CLI::App] The current context of the command.
    # @return [void]
    def self.define_api_version_command(command_context)
      command_context.desc 'Display API Version'
      command_context.command :api_version do |api_version_command|
        api_version_command.action do |global_options, options, args|
          self.new(global_options).api_version_command(options, args)
        end
      end
    end

    # Define `manager_time` command_context
    # @param command_context [CLI::App] The current context of the command.
    # @return [void]
    def self.define_manager_time_command(command_context)
      command_context.desc 'Display Manager time'
      command_context.command :manager_time do |manager_time_command|
        manager_time_command.action do |global_options, options, args|
          self.new(global_options).manager_time_command(options, args)
        end
      end
    end

    # Define `list` command_context
    # @param command_context [CLI::App] The current context of the command.
    # @yieldparam list_command [GLI::Command] The just defined list command_context
    # @yield [list_command] Gives the list command_context to the block
    # @return [void]
    def self.define_list_command(command_context)
      command_context.desc "List #{self.transport_class_string}s"
      command_context.command :list do |list_command|
        define_fields_flag(list_command)
        yield list_command if block_given?
        list_command.action do |global_options, options, args|
          self.new(global_options).list_command(options, args)
        end
      end
    end

    # Define `schema` command_context
    # @param command_context [CLI::App] The current context of the command.
    # @yieldparam schema_command [GLI::Command] The just defined schema command_context
    # @yield [schema_command] Gives the schema command_context to the block
    # @return [void]
    def self.define_schema_command(command_context)
      command_context.desc "Show #{self.transport_class_string} schema"
      command_context.command :schema do |schema_command|
        yield schema_command if block_given?
        schema_command.action do |global_options, options, args|
          self.new(global_options).schema_command(options, args)
        end
      end
    end

    # @!endgroup

    # @!group Command Implementations

    # `api_version` Implementation.
    # Display the API version in use by the DeepSecurity Manager.
    # @note Does not require authentication
    # @param options [Hash<Symbol => Object>] Merged global/local options from GLI
    # @param args [Array<String>] Arguments from GLI
    # @return [void]
    def api_version_command(options, args)
      output do |output|
        connect do |dsm|
          output.puts dsm.api_version()
        end
      end
    end

    # `manager_time` Implementation.
    # Display the local time of the DeepSecurity Manager.
    # @note Does not require authentication
    # @param options [Hash<Symbol => Object>] Merged global/local options from GLI
    # @param args [Array<String>] Arguments from GLI
    # @return [void]
    def manager_time_command(options, args)
      output do |output|
        connect do |dsm|
          output.puts dsm.manager_time()
        end
      end
    end

    # `schema` Implementation.
    # Display schema of the current datatype (defined by `transport_class`).
    # @note Does not require authentication
    # @param options [Hash<Symbol => Object>] Merged global/local options from GLI
    # @param args [Array<String>] Arguments from GLI
    # @return [void]
    def schema_command(options, args)
      output do |output|
        schema = self.class.schema()
        schema.keys.sort.each do |key|
          output.puts "#{key} (#{schema[key].type_string}): #{schema[key].description}"
        end
      end
    end

    # @!endgroup

  end

end