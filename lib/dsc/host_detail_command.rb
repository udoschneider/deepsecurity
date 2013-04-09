# @author Udo Schneider <Udo.Schneider@homeaddress.de>

module Dsc

   # This class defines the arguments, options and implementation for the `host_detail` command/subcommand.
  class HostDetailCommand < Command

    # DeepSecurity object covered by this class.
    # @return [DeepSecurity::HostDetail]
    def self.transport_class
      DeepSecurity::HostDetail
    end

    # @!group Fields flag

    # Default fields if no argument is given
    # @return [Array<String>] Default fields if no argument is given
    def self.default_fields
      [
          # DNS name of system
          :name,

          # fully qualified of system
          :display_name,

          # signature / pattern version currently in use
          :anti_malware_classic_pattern_version,
          :anti_malware_engine_version,
          :anti_malware_intelli_trap_exception_version,
          :anti_malware_intelli_trap_version,
          :anti_malware_smart_scan_pattern_version,
          :anti_malware_spyware_pattern_version,

          # Last datetime the system was active/online
          :overall_last_successful_communication,

          #  OS version
          :platform,
          :host_type,
          # system domain or system group
          :host_group_name,

      # last/currently logged on account
      ]
    end

    # @!endgroup

    # @!group Command definitions

    # Define all commands for this available for this (sub) command_context
    # @param command_context [CLI::App] The current context of the command.
    # @return [void]
    def self.define_commands(command_context)
      command_context.desc "Access #{transport_class_string()}s"
      command_context.command command_symbol do |host_detail_command|
        define_list_command(host_detail_command)
        define_schema_command(host_detail_command)
      end
    end

    # Define `list` command_context
    # @param command_context [CLI::App] The current context of the command.
    # @yieldparam list_command [GLI::Command] The just defined list command_context
    # @yield [list_command] Gives the list command_context to the block
    # @return [void]
    def self.define_list_command(command_context)
      super(command_context) do |list_command|
        define_detail_level_flag(list_command)
        define_time_format_flag(list_command)
      end
    end

    # @!endgroup

    # @!group Command Implementations

    # `list` Implementation.
    # List all entries of the `transport_class` type according to given filter parameters.
    # @param options [Hash<Symbol => Object>] Merged global/local options from GLI
    # @option options [String] :fields The fields to display.
    # @option options [String] :detail_level Query Level to request.
    # @param args [Array<String>] Arguments from GLI
    # @return [void]
    def list_command(options, args)
      fields = parse_fields(options[:fields])
      detail_level = parse_detail_level(options[:detail_level])
      output do |output|
        authenticate do |manager|
          hostFilter = DeepSecurity::HostFilter.all_hosts
          progressBar = ProgressBar.new("host_status", 100) if @show_progress_bar
          hostDetails = manager.host_details(hostFilter, detail_level)
          progressBar.set(25) if @show_progress_bar
          csv = CSV.new(output)
          csv << fields
          hostDetails.each do |hostDetail|
            progressBar.inc(75/hostDetails.size) if @show_progress_bar
            csv << fields.map do |attribute|
              begin
                to_display_string(hostDetail.instance_eval(attribute))
              rescue => e
                 "ERROR (#{e.message})"
              end
            end
          end
          progressBar.finish if @show_progress_bar
        end
      end
    end

    # @!endgroup
  end

end