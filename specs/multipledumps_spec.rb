
require_relative 'spec_helper'

describe Stacky::MultipleDumps,'#parse' do

  it 'should do something' do

    result = Stacky::MultipleDumps.parse(open(fixture('complete_multiple.txt')).lines)

    expect(result.size).to eq(4)
  end
end