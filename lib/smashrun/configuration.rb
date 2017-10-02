module HealthGraph
  module Configuration
    attr_accessor :client_id, :client_secret
    
    def configure
      yield self
    end
  end
end
