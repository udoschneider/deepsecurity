module DeepSecurity

  class DSObject < SavonHelper::CachingObject

    def self.logger
      DeepSecurity.logger
    end

    def self.dsm
      DeepSecurity.dsm
    end

    def logger
      self.class.logger
    end

    def dsm
      self.class.dsm
    end

    def retryable(options = {}, &block)
      opts = {:tries => 1, :on => Exception}.merge(options)

      retry_exception, retries = opts[:on], opts[:tries]

      begin
        return yield
      rescue retry_exception
        retry if (retries -= 1) > 0
      end

      yield
    end

  end

end