module DeepSecurity
  # This class encapsulates Exceptions from the underlying SOAP Backend.
  # The intention is to prevent implementation details (the SOAP lib used in this case)
  # from leaking out to module users
  class SOAPException < Exception
  end
end