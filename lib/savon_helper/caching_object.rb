# @author Udo Schneider <Udo.Schneider@homeaddress.de>

module SavonHelper

  class CachingObject < MappingObject

    @@cache_aspects = Hash.new()

    # @group Caching

    def self.cache_aspects
      aspect = @@cache_aspects[self]
      return aspect if !aspect.nil?
      @@cache_aspects[self] = Set.new()
      @@cache_aspects[self]
    end

    def self.cache_by_aspect(*symbols)
      symbols.each { |each| cache_aspects.add(each) }
    end

    def self.cache_key(aspect, value)
      "#{self}-#{aspect}-#{value}"
    end

    def cache_aspects
      self.class.cache_aspects
    end

    def cache_key(aspect)
      self.class.cache_key(aspect, self.send(aspect))
    end

    def cachable?
      !cache_aspects.empty?
    end

    def cache
      DeepSecurity::Manager.current.cache
    end

    def store_in_cache
      cache_aspects.each { |aspect| cache.store(self.cache_key(aspect), self) }
    end

  end

end
