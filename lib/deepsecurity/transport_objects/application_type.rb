module DeepSecurity

  # Represents an Application Type that reflects some network attributes to which DPI rules are assigned. The DPI engine
  # will determine if a DPI rule should apply to a connection based on the assigned Application Type network attributes.
  class ApplicationType < TransportObject

    attr_integer_accessor :id, "ApplicationTypeTransport ID"
    attr_string_accessor :description, "ApplicationTypeTransport description"
    attr_string_accessor :name, "ApplicationTypeTransport name"
    attr_string_accessor :tbuid, "Internal TBUID of a Trend Micro issued Application Type"
    attr_enum_accessor :direction, EnumDirection, 'The initial direction of the connection which this ApplicationTypeTransport would apply, e.g., INCOMING, OUTGOING. Depending on whether the application type is a server or client, the initial direction of the connection to inspect would either be INCOMING for a server, or OUTGOING for a client. E.g. Inspection of "Web Server Common" Application Type for a connection stream on TCP port 80 would be initially an INCOMING direction because incoming Web Server connections should be inspected'
    attr_boolean_accessor :ignore_recommendations, "Whether the Recommendation Engine should ignore this rule"
    attr_object_accessor :protocol_icmp, ProtocolICMP, "ApplicationTypeTransport protocol ICMP type"
    attr_object_accessor :protocol_port_based, ProtocolPortBased, 'ApplicationTypeTransport protocol Port type'
    attr_enum_accessor :protocol_type, EnumApplicationTypeProtocolType, 'ApplicationTypeTransport protocol Application type, e.g., UCMP, TCP, UDP, TCP_UDP'
    attr_boolean_accessor :authoritative, 'Whether the rule is an internal read only Trend Micro rule'

    cache_by_aspect :id, :name

  end

  class Manager

    def application_types
      cache.fetch(ApplicationType.cache_key(:all, :all)) do
        request_array("application_type_retrieve_all", ApplicationType)
      end
    end

    def application_type(id)
      cache.fetch(ApplicationType.cache_key(:id, id)) do
        request_object("application_type_retrieve", ApplicationType, {:id => id})
      end
    end

    def application_type_by_name(name)
      cache.fetch(ApplicationType.cache_key(:name, name)) do
        request_object("application_type_retrieve_by_name", ApplicationType, {:name => name})
      end
    end

  end

end