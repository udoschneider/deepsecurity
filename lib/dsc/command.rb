require "progressbar"
require "csv"

module Dsc

  class Command

    def self.transport_class
      nil
    end

    def self.transport_class_name
      class_name = transport_class.name.split('::').last || ''
    end

    def self.transport_class_string
      transport_class_name.split(/(?=[A-Z])/).join(" ")
    end

    def self.command_symbol
      transport_class_name.split(/(?=[A-Z])/).join("_").downcase.to_sym
    end

    def self.schema
      transport_class.mappings
    end

    def initialize(global_options)
      @hostname = global_options[:m]
      @port = global_options[:port].to_i
      @tenant = global_options[:t]
      @username =global_options[:u]
      @password = global_options[:p]
      @show_progress_bar = global_options[:P]
      @debug_level = debug_level_from_option(global_options[:d])
      @output = global_options[:o]
    end

    def self.valid_debug_levels
      DeepSecurity::LOG_MAPPING.keys
    end

    def self.valid_debug_levels_string
      valid_debug_levels.join(", ")
    end

    def self.default_fields
      []
    end

    def self.default_fields_string
      default_fields.join(",")
    end

    def self.valid_fields
      transport_class.defined_attributes.sort
    end

    def self.valid_fields_string
      valid_fields.join(", ")
    end

    def parse_fields(string)
      fields = string.split(",").map(&:strip)
      unknown_fields = fields.reject { |each| self.class.transport_class.has_attribute_chain(each) }
      raise "Unknown field found (#{unknown_fields.join(', ')}) - known fields are: #{self.class.valid_fields.join(', ')}" unless unknown_fields.empty?
      fields
    end

    def self.valid_time_filters
      {
          :last_hour => DeepSecurity::TimeFilter.last_hour,
          :last_24_hours => DeepSecurity::TimeFilter.last_24_hours,
          :last_7_days => DeepSecurity::TimeFilter.last_7_days,
          :last_day => DeepSecurity::TimeFilter.last_day
      }
    end

    def self.valid_time_filters_string
      valid_time_filters.keys.join(', ')
    end

    def parse_time_filter(string)
      filter = self.class.valid_time_filters[string.to_sym]
      raise "Unknown time filter" if filter.nil?
      filter
    end

    def self.valid_detail_levels
      EnumHostDetailLevel.keys()
    end

    def self.valid_detail_levels_string
      valid_detail_levels.join(", ")
    end

    def parse_detail_level(string)
      detail_level = EnumHostDetailLevel[string.upcase.strip]
      return detail_level unless detail_level.nil?
      return EnumHostDetailLevel["LOW"]
    end


    def debug_level_from_option(option)
      return nil if option.blank?
      return option.to_sym if (DeepSecurity::LOG_MAPPING.keys.include?(option.to_sym))
      :debug
    end

    def output
      unless @output == '--'
        output = File.open(option, 'w')
      else
        output = STDOUT
      end
      yield output
      output.close() unless @output == '--'
    end

    def connect
      yield DeepSecurity::Manager.server(@hostname, @port, @debug_level)
    end

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


    def print_api_version(options, args)
      output do |output|
        authenticate do |dsm|
          output.puts dsm.api_version()
        end
      end
    end

    def print_manager_time(options, args)
      output do |output|
        authenticate do |dsm|
          output.puts dsm.manager_time()
        end
      end
    end

    def print_schema(options, args)
      output do |output|
        schema = self.class.schema()
        schema.keys.sort.each do |key|
          output.puts "#{key} (#{schema[key].type_string}): #{schema[key].description}"
        end
      end
    end

    def self.define_list_command(command)
      command.desc "List #{self.transport_class_string}s"
      command.command :list do |list|
        define_fields_argument(list)
        yield list if block_given?
        list.action do |global_options, options, args|
          self.new(global_options).list(options, args)
        end
      end
    end

    def self.define_schema_command(command)
      command.desc "Show #{self.transport_class_string} schema"
      command.command :schema do |schema|
        yield schema if block_given?
        schema.action do |global_options, options, args|
          self.new(global_options).print_schema(options, args)
        end
      end
    end

    def self.define_time_filter_argument(command)
      command.desc "A filter specifying the time interval to query (One of #{self.valid_time_filters_string})"
      command.default_value "last_day"
      command.flag [:time_filter]
    end

    def self.define_fields_argument(command)
      command.desc "A comma separated list of fields to display. (Available fields: #{self.valid_fields_string})"
      command.default_value self.default_fields_string
      command.flag [:fields]
    end

  end

end