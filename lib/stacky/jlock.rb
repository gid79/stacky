
module Stacky
  class JLock
    attr_reader :locked, :lock_id, :state_description, :type

    def self.parse_line(line)
      #- locked <7c47230e0> (a java.net.SocksSocketImpl)
      if match = line.match(/^-(.*)<([\d\w]+)> \(a (.*)\)$/)
        desc, lock_id, type = match.captures
        state_description = desc.strip
        locked = state_description.include? 'locked'
        JLock.new locked, lock_id, state_description, type
      else
        raise "un recognised lock line [#{line}]"
      end
    end
    
    def initialize(locked, lock_id, state_description, type)
      @locked, @lock_id, @state_description, @type = locked, lock_id, state_description, type
    end
    
    def locked?
      locked
    end
  end
end