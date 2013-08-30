
require_relative 'spec_helper'

describe Stacky::JLock, '#parse_line' do
  context 'creating from a string' do
    it 'locked state' do
      result = Stacky::JLock.parse_line '- locked <7c47230e0> (a java.net.SocksSocketImpl)'
      expect(result.locked).to be true
      expect(result.state_description).to eq('locked')
      expect(result.lock_id).to eq('7c47230e0')
      expect(result.type).to eq('java.net.SocksSocketImpl')
    end
    it 'waiting state' do
      result = Stacky::JLock.parse_line '- waiting on <7c46f65b8> (a java.lang.Object)'
      expect(result.locked).to be false
      expect(result.state_description).to eq('waiting on')
      expect(result.lock_id).to eq('7c46f65b8')
      expect(result.type).to eq('java.lang.Object')
    end
    it 'parking to wait' do
      result = Stacky::JLock.parse_line '- parking to wait for  <7c3e234a0> (a java.util.concurrent.locks.AbstractQueuedSynchronizer$ConditionObject)'
      expect(result.locked).to be false
      expect(result.state_description).to eq('parking to wait for')
      expect(result.lock_id).to eq('7c3e234a0')
      expect(result.type).to eq('java.util.concurrent.locks.AbstractQueuedSynchronizer$ConditionObject'      )
    end
  end
end