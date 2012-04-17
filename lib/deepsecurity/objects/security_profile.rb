module DeepSecurity

  class SecurityProfile

  end

  class Manager

    def security_profiles
      cache.fetch(SecurityProfile.cache_key(:all, :all)) do
        request_array("security_profile_retrieve_all", SecurityProfile)
      end
    end

    def security_profile(id)
      cache.fetch(SecurityProfile.cache_key(:id, id)) do
        request_object("security_profile_retrieve", SecurityProfile, {:id => id})
      end
    end

    def security_profile_by_name(name)
      cache.fetch(SecurityProfile.cache_key(:name, name)) do
        request_object("security_profile_retrieve_by_name", SecurityProfile, {:name => name})
      end
    end

  end

end