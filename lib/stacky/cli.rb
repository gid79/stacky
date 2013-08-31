require 'thor'
require 'stacky'

module Stacky
  class Cli < Thor
    desc 'hello', 'hello world again'

    def hello
      puts 'wibble wibble'
    end
  end
end
