
module Stacky
  class JThread
    attr_reader :name, :prio, :tid, :nid, :state, :state_description, :daemon, :stackframes, :description

    def self.parse(lines)
      name, prio, tid, nid, daemon, description = parse_first lines.first.strip
      if lines.size > 1
        state, state_description = parse_threadstate lines[1].strip
      end
      stackframes = if lines.size > 2
                      JStackframe.parse lines[2..-1]
                    else
                      []
                    end
      JThread.new(name, prio, tid, nid, state, state_description, daemon, stackframes, description)
    end

    def self.parse_first(line)
      #"Attach Listener" daemon prio=9 tid=128111000 nid=0x128b40000 waiting on condition [00000000]
      if match = line.match( /^"(.*)".*prio=([0-9a-f]+) tid=([0-9a-f]+) nid=(0x[0-9a-f]+) (.*)$/ )
        name, prio, tid, nid, rest = match.captures
        prio = prio.to_i
        description = rest # todo stip the last part of the thread line [132131]
      end
      daemon = line.include? "daemon"
      return name, prio, tid, nid, daemon, description
    end

    def self.parse_threadstate(line)
      if match = line.match(/^java.lang.Thread.State: ([\w_]+)(.*)$/)
        state, rest = match.captures
        if match = rest.match(/\((.*)\)/)
          state_description = match[1]
        end
      end
      return state, state_description
    end

    def initialize(name, prio, tid, nid, state, state_description, daemon, stackframes, description)
      @name, @prio, @tid, @nid, @state, @state_description, @daemon, @stackframes, @description = name, prio, tid, nid, state, state_description, daemon, stackframes, description
    end
  end
end