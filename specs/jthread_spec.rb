
require 'stacky'

describe Stacky::JThread,"constructor" do
  it "should extract the first line details" do
    result = Stacky::JThread.new ['"Thread-16" daemon prio=4 tid=10ee26800 nid=0x12b7a4000 waiting on condition [12b7a3000]']
    expect(result.name).to eq('Thread-16')
    expect(result.daemon).to be true
    expect(result.tid).to eq('10ee26800')
    expect(result.nid).to eq('0x12b7a4000'    )
    expect(result.prio).to eq(4)
  end
  
  it "should parse without the daemon flag" do
    result = Stacky::JThread.new ['"Smack Packet Writer" prio=4 tid=10ea07000 nid=0x12c8fe000 in Object.wait() [12c8fd000]']
    expect(result.daemon).to be false
  end
  
  context "parse the thread state" do
    it "when the description isn't present" do
      result = Stacky::JThread.new ['', 'java.lang.Thread.State: RUNNABLE']
      expect(result.state).to eq('RUNNABLE')
    end
    it "when the description is present" do
      result = Stacky::JThread.new ['', 'java.lang.Thread.State: WAITING (on object monitor)']
      expect(result.state).to eq('WAITING')
      expect(result.state_description).to eq('on object monitor')
    end
  end
  
  
end