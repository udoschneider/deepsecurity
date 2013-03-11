module DeepSecurity

  # The Host's Interface Transport Object.
  class HostInterface < TransportObject

    attr_integer_accessor :id
    attr_string_accessor :name
    attr_string_accessor :description

    attr_string_accessor :display_name,
                         'Computer display name'
    attr_boolean_accessor :external,
                          'Administrative external boolean for integration purposes.'
    attr_string_accessor :external_id,
                         'Administrative external ID for integration purposes.'
    attr_integer_accessor :host_group_id,
                          'Assigned HostGroupTransport ID'
    attr_enum_accessor :host_type,
                       EnumHostType,
                       'Assigned host type'
    attr_string_accessor :platform,
                         'Computer platform'
    attr_integer_accessor :security_profile_id,
                          'Assigned SecurityProfileTransport ID'

    # ABOVE COPIED FROM HOST!

    attr_boolean_accessor :dhcp,
                          "DHCP On or Off"
    attr_integer_accessor :host_bridge_id,
                          "The ID of the Host Bridge"
    attr_integer_accessor :interface_type_id,
                          "The ID of the Interface Type"
    attr_string_accessor :mac,
                         "Mac Address"
    attr_boolean_accessor :not_available,
                          "True is the HostInterface isn't available"
    attr_integer_accessor :virtual_device_key,
                          "The Virtual Device Key"

  end
end