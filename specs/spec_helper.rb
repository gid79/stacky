dir = File.dirname(File.expand_path(__FILE__))
$LOAD_PATH.unshift dir + '/../lib'

require 'stacky'

def fixture(filename)
  File.join(File.dirname(__FILE__),'fixtures',filename)
end

