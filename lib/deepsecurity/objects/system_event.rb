module DeepSecurity

  class SystemEvent < DSMObject

    # Represents a Deep Security Manager System event. A System event can target many different aspects of Deep
    # Security, such as a configuration change to a Security Profile or Computer setting, or applying a Security Update to a Computer.

    attr_string_accessor :action_performed_by, :description, :event
    attr_integer_accessor :event_id
    attr_enum_accessor EnumEventOrigin, :event_origin
    attr_string_accessor :manager_hostname
    attr_integer_accessor :system_event_id
    attr_string_accessor :tags, :target
    attr_integer_accessor :target_id
    attr_string_accessor :target_type
    attr_datetime_accessor :time
    attr_string_accessor :type

    # cache_by_aspect :id, :name


  end

  class Manager

    # Retrieves the system events specified by the time, host and event ID filters. System events that do not pertain
    # to hosts can be included or excluded.
    def system_events(timeFilter, hostFilter, eventIdFilter, includeNonHostEvents)
      events = send_authenticated_request("system_event_retrieve", {
          :timeFilter => timeFilter.as_hash,
          :hostFilter => hostFilter.as_hash,
          :eventIdFilter => eventIdFilter.as_hash,
          :includeNonHostEvents => includeNonHostEvents ? "true" : "false"})[:system_events]
      return [] if events.nil?
      events[:item].map do |each|
        SystemEvent.from_hash(self, each)
      end
    end

  end

end
