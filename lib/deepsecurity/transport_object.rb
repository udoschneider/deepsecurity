# @author Udo Schneider <Udo.Schneider@homeaddress.de>

module DeepSecurity

  # @abstract
  # Transport objects are modeled after Deep Security Manager web interface objects and configuration groups. These
  # transport objects can be constructed as new or retrieved from the Manager by calling the appropriate web method.
  #
  # A Web Service definition may declare object classes that inherit properties from other base object classes, so only
  # the relevant object classes are covered in this section. If during development, you encounter any WSDL-defined
  # object classes that are not documented, they are likely inherited base object classes or response object classes
  # that are not directly used by any Web Methods and do not have any direct value.
  #
  # @note
  #   It defines it's own DSL to specify attributes, caching and operation. This allows you to completely hide the
  #   type-conversion needed by Savon behind a regular Ruby object.
  class TransportObject < SavonHelper::CachingObject

    def manager
      interface.manager
    end

  end

end
