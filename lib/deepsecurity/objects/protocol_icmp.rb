module DeepSecurity

  class ProtocolICMP < TransportObject

    attr_enum_accessor :type, EnumProtocolIcmpType

    def cache_seperatly?
      false
    end

  end

end
