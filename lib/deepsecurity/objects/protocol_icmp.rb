module DeepSecurity

  class ProtocolICMP < DSMObject

    attr_enum_accessor EnumProtocolIcmpType, :type

    def cache_seperatly?
      false
    end

  end

end
