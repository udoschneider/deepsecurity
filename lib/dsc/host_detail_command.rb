module Dsc

  class HostDetailCommand < Command


    def self.transport_class
      DeepSecurity::HostDetail
    end

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
          :host_group_id,

      # last/currently logged on account
      ]
    end

    def list(options, args)
      fields = parse_fields(options[:fields])
      output do |output|
        authenticate do |dsm|
          hostFilter = DeepSecurity::HostFilter.all_hosts
          progressBar = ProgressBar.new("host_status", 100) if @show_progress_bar
          hostDetails = DeepSecurity::HostDetail.find_all(hostFilter, :low)
          progressBar.set(25) if @show_progress_bar
          csv = CSV.new(output)
          csv << fields
          hostDetails.each do |hostDetail|
            progressBar.inc(75/hostDetails.size) if @show_progress_bar
            csv << fields.map { |attribute| hostDetail.instance_eval(attribute) }
          end
          progressBar.finish if @show_progress_bar
        end
      end
    end
  end

end