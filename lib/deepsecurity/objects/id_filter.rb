module DeepSecurity

  # Used as a search criteria to limit the scope of objects returned by event transport object ID. Each event transport
  # object, such as IntegrityEventTransport, includes an ID property that is assigned as the primary key of an event
  # when it is generated by a computer agent. Using IDFilterTransport, it is possible to filter event retrieval by this
  # event ID in order to retrieve a specific event by ID, or events that are greater or less than a specified ID. For
  # example, a utility that is designed to retrieve all new events on an interval can use the event ID property to
  # uniquely identify which events have already been retrieved. This way retrieval of duplicate events can be avoided.
  class IDFilter < TransportObject

    attr_integer_accessor :id
    attr_enum_accessor :operator, EnumOperator

    def self.equals(id)
      instance = self.new()
      instance.operator = :equals
      instance.id =id
      instance
    end

    def self.less_than(id)
      instance = self.new()
      instance.operator = :less_than
      instance.id =id
      instance
    end

    def self.greater_than(id)
      instance = self.new()
      instance.operator = :greater_than
      instance.id =id
      instance
    end

  end

end
