
module Stacky
  class JLock
    attr_reader :locked, :lock_id, :state_description, :type
    
    def initialize(line)
      #- locked <7c47230e0> (a java.net.SocksSocketImpl)
      if match = line.match(/^-(.*)<([\d\w]+)> \(a (.*)\)$/)
        desc, @lock_id, @type = match.captures
        @state_description = desc.strip
        @locked = state_description.include? 'locked'
      end
    end
    
    def locked?
      locked
    end
  end
end