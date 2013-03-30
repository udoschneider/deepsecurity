# @author Udo Schneider <Udo.Schneider@homeaddress.de>

require "cache"

module SavonHelper

  class CachingObject < MappingObject

    @@cache_aspects = Hash.new { |hash, key| hash[key] = Set.new() }
    @@cache = Cache.new(nil, nil, 10000, 5*60)

    # @!group Caching

    def self.cache_aspects
      @@cache_aspects[self]
    end

    def self.all_cache_aspects
      self.superclass.all_cache_aspects + cache_aspects()
    end

    def self.cache_by_aspect(*symbols)
      symbols.each { |each| cache_aspects.add(each) }
    end

    def self.cache_key(aspect, value)
      "#{self.name_without_namespace}-#{aspect}-#{value}"
    end

    def cache_key(aspect)
      self.class.cache_key(aspect, self.send(aspect))
    end

    def cachable?
      !all_cache_aspects.empty?
    end

    def cache
      @@cache
    end

    def store_in_cache
      all_cache_aspects.each { |aspect| cache.store(self.cache_key(aspect), self) }
    end

    # @! endgroup

    # @!group Mapping

    # Return an initialized instance with the values from the (type-converted) hash. Store the instance in cache
    # if cacheable.
    # @see #store_in_cache
    #
    # @param data [Hash] A hash of simple types as provided by Savon
    # @return [MappingObject] The initialized instance.
    def self.from_savon(data, interface)
      instance = super(data, interface)
      instance.store_in_cache if instance.cachable?
      instance
    end

    # @!endgroup
  end

end

class Object

  def cache_aspects
    self.class.cache_aspects
  end

  def self.cache_aspects
    Set.new()
  end

  def all_cache_aspects
    self.class.all_cache_aspects
  end

  def self.all_cache_aspects
   Set.new()
  end

end
