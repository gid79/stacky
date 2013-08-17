
require 'stacky'

describe Stacky::Dump, "#parse" do
  it "should be able to parse complete_single.txt" do
    result = Stacky::Dump.parse(open("fixtures/complete_single.txt")).first()
    result.ts.should eq('2013-07-07 14:43:32')
    result.jvm_build.should eq('20.51-b01-456')
    expect(result.jni_global_references).to be 3520
    expect(result.threads.size).to be > 1
  end
  
  it "should parse min.txt" do
    result = Stacky::Dump.parse(open("fixtures/min.txt")).first()
    expect(result.threads.size).to be == 1
  end
end

