

module Stacky
  class Dump
    attr_accessor :ts,:jvm_build, :threads, :jni_global_references
    
    def initialize()
      @threads = []
    end
    
    def self.parse(input)
      d = Dump.new
      current = []
            
      input.lines.each do |line| 
        line = line.strip
        case line
        when /2\d{3}-\d\d-\d\d \d\d:\d\d:\d\d/
          d.ts = line
        when /^Full thread dump.*/
          m = line.match(/^.+\(([\d\w\.\-]*).+\):$/)
          d.jvm_build = m[1] if m
        when /^JNI global references: (\d+)$/
          d.jni_global_references = $1.to_i
        when /^".+" .*$/
          # puts "start of thread"
          # ie
          # "Attach Listener" daemon prio=9 tid=128111000 nid=0x128b40000 waiting on condition [00000000]
          current = [line]
        when /^$/
          # puts "empty line #{current}"
          if not current.empty?
            # puts "parsing JThread"
            d.threads << JThread.parse(current)
          end
          current = []          
        else
          # puts "non-empty line #{current}"
          if not current.empty?
            current << line
          end
        end        
      end
      [d]
    end
      
  end

end