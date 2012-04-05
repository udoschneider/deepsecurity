module DeepSecurity

  class ProtocolPortBased < DSMObject

    attr_integer_accessor :port_list_id
    attr_enum_accessor EnumPortType, :port_type
    attr_string_accessor :ports

  end

end