module DeepSecurity

  class ProtocolPortBased < TransportObject

    attr_integer_accessor :port_list_id
    attr_enum_accessor :port_type, EnumPortType
    attr_string_accessor :ports

  end

end