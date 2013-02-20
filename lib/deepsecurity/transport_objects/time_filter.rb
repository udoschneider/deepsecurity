module DeepSecurity

  # Used as search criteria limit the scope of objects returned by time related attributes, such as from, to, or a
  # specific time. If the type is set to EnumTimeFilterType CUSTOM_RANGE, then the rangeFrom and rangeTo property will
  # be required. If the EnumTimeFilterType SPECIFIC_TIME type is set, then the specifiicTime property will be required.
  class TimeFilter < TransportObject

    attr_datetime_accessor :range_from
    attr_datetime_accessor :range_to
    attr_datetime_accessor :specific_time
    attr_integer_accessor :host_group_id
    attr_integer_accessor :host_id
    attr_integer_accessor :security_profile_id
    attr_enum_accessor :type, EnumTimeFilterType

    def self.last_hour
      instance = self.new()
      instance.type = :last_hour
      instance
    end

    def self.last_24_hours
      instance = self.new()
      instance.type = :last_24_hours
      instance
    end

    def self.last_7_days
      instance = self.new()
      instance.type = :last_7_days
      instance
    end

    def self.custom_range(range)
      instance = self.new()
      instance.type = :custom_range
      instance.range_from = range.first
      instance.range_to = range.last
      instance
    end

    def self.specific_time(datetime)
      instance = self.new()
      instance.type = :specific_time
      instance.specific_time = datetime
      instance
    end

  end

end
