
module Stacky
  class JStackframe
    attr_reader :type, :method, :source, :line, :locks
    
    def self.parse(lines)
      converted = lines.map do |line|
        stripped_line = line.strip
        case stripped_line
        when /^at.*$/
          # at java.lang.Object.wait(Object.java:485)
          JStackframe.parse_line stripped_line
        when /^-.*$/
          JLock.new stripped_line
        else
          puts "Warning: Unable to parse #{line}"
          nil
        end
      end
      converted.inject [] do |result, frame_or_lock|
        if frame_or_lock.is_a? JLock
          frame = result.last()
          frame.locks << frame_or_lock
        elsif not frame_or_lock.nil?
          result << frame_or_lock
        end
        result
      end
    end
    
    def self.parse_line(line)
      if match = line.match(/^at (.*)\.(.*)\((.*)\)/)
        type, method, location = match.captures
        if location_match = location.match(/(.+):(\d+)/)
          source, line = location_match.captures
          line = line.to_i
        else
          source = location
          line = nil
        end
        JStackframe.new(type, method, source, line, [])
      else
        raise "invalid input for parse_line:#{line}"
      end
    end

    def initialize(type, method, source, line, locks)
      @type, @method, @source, @line, @locks = type, method, source, line, Array.new(locks)
    end

  end
end