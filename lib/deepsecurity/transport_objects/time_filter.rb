module DeepSecurity

  # Used as search criteria limit the scope of objects returned by time related attributes, such as from, to, or a
  # specific time. If the type is set to EnumTimeFilterType CUSTOM_RANGE, then the rangeFrom and rangeTo property will
  # be required. If the EnumTimeFilterType SPECIFIC_TIME type is set, then the specifiicTime property will be required.
  class TimeFilter < TransportObject

    attr_datetime_accessor :rangeFrom,
                           "Time range start to filter computers by." ,
                           :range_from
    attr_datetime_accessor :rangeTo,
                           "Time range end to filter computers by.",
                           :range_to
    attr_datetime_accessor :specificTime,
                           "Specific time to filter computers by.",
                           :specific_time
    # attr_integer_accessor :host_group_id
    # attr_integer_accessor :host_id
    # attr_integer_accessor :security_profile_id
    attr_enum_accessor :type, EnumTimeFilterType,
                       "EnumTimeFilterType to filter computers by."

    # @!group High-Level SOAP Wrapper

    # Return a new instance for the last hour.
    # @return [TimeFilter]
    def self.last_hour
      instance = self.new()
      instance.type = :last_hour
      instance
    end

    # Return a new instance for the last 24 hours.
    # @return [TimeFilter]
    def self.last_24_hours
      instance = self.new()
      instance.type = :last_24_hours
      instance
    end


    # Return a new instance for the last 7 days.
    # @return [TimeFilter]
    def self.last_7_days
      instance = self.new()
      instance.type = :last_7_days
      instance
    end

    # Return a new instance for the given datetime range.
    # @param datetime_range [Range] A range of two datetimes
    # @return [TimeFilter]
    def self.custom_range(datetime_range)
      instance = self.new()
      instance.type = :custom_range
      instance.range_from = datetime_range.first
      instance.range_to = datetime_range.last
      instance
    end

    # Return a new instance for the given datetime.
    # @deprecated Please use {#specific_time} instead
    # @param datetime [DateTime]
    # @return [TimeFilter]
    def self.specificTime(datetime)
      self.specific_time(datetime)
    end

    # Return a new instance for the given datetime.
    # @param datetime [DateTime]
    # @return [TimeFilter]
    def self.specific_time(datetime)
      instance = self.new()
      instance.type = :specific_time
      instance.specific_time = datetime
      instance
    end


    # Return a new instance for last day (yesterday 00:00:00UTC-23:59:59UTC).
    # @return [TimeFilter]
    def self.last_day
      self.custom_range(((Date.today-1).to_time)..((Date.today).to_time-1))
    end

    # @!endgroup

  end

end
