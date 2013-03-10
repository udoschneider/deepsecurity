module DeepSecurity

  # Used as search criteria limit the scope of objects returned by time related attributes, such as from, to, or a
  # specific time. If the type is set to EnumTimeFilterType CUSTOM_RANGE, then the rangeFrom and rangeTo property will
  # be required. If the EnumTimeFilterType SPECIFIC_TIME type is set, then the specifiicTime property will be required.
  class TimeFilter < TransportObject

    attr_datetime_accessor :rangeFrom
    attr_datetime_accessor :rangeTo
    attr_datetime_accessor :specificTime
    # attr_integer_accessor :host_group_id
    # attr_integer_accessor :host_id
    # attr_integer_accessor :security_profile_id
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
      instance.rangeFrom = range.first
      instance.rangeTo = range.last
      instance
    end

    def self.specificTime(datetime)
      instance = self.new()
      instance.type = :specificTime
      instance.specificTime = datetime
      instance
    end

  end

end
