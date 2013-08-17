
module Stacky
  class JThread
    attr_reader :name, :prio, :tid, :nid, :state, :state_description, :daemon, :lines, :description
    
    def initialize(lines)
      @lines = lines
      parse_first lines.first
      if lines.size > 1
        parse_threadstate lines[1]
      end
    end    
    
    private 
    def parse_first(line)
      #"Attach Listener" daemon prio=9 tid=128111000 nid=0x128b40000 waiting on condition [00000000]
      if match = line.match( /^"(.*)".*prio=([0-9a-f]+) tid=([0-9a-f]+) nid=(0x[0-9a-f]+) (.*)$/ )
        @name, prio, @tid, @nid, rest = match.captures
        @prio = prio.to_i
        @description = rest # todo stip the last part of the thread line [132131]
      end
      @daemon = line.include? "daemon"
    end
    
    def parse_threadstate(line)
      if match = line.match(/^java.lang.Thread.State: ([\w_]+)(.*)$/)
        @state, rest = match.captures
        if match = rest.match(/\((.*)\)/)
          @state_description = match[1]
        end
      end
    end
  end
end