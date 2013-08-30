

module Stacky
  class MultipleDumps
    include Enumerable

    def self.parse(lines)
      dumps = []
      current = []

      lines.each do |line|
        if line.match(/2\d{3}-\d\d-\d\d \d\d:\d\d:\d\d/)
          unless current.empty?
            dumps << Stacky::Dump.parse(current)
            current = []
          end
        end
        current << line
      end
      unless current.empty?
        dumps << Stacky::Dump.parse(current)
      end
      MultipleDumps.new(dumps)
    end

    def initialize(dumps)
      @dumps = dumps
    end

    def each
      if block_given?
        @dumps.each {|it| yield it}
      else
        @dumps.each
      end
    end

    def size
      @dumps.size
    end
  end

end
