module PoolParty
  class RemoteInstance
    attr_reader :ip, :instance_id
    attr_accessor :name
    
    def initialize(obj)
      @ip = obj[:ip]
      @instance_id = obj[:instance_id]
      @name = obj[:name] || "node#{rand(1000)}"
    end
    
    def host_entry
      "#{@name}\t#{@ip}"
    end
    
    def haproxy_entry
      "server #{@name} #{@ip}:#{Application.client_port} weight 1 maxconn 3 check inter 30000"
    end
    
  end
end