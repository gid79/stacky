
require_relative 'spec_helper'

describe Stacky::JStackframe, '#parse_line' do
  it 'should parse a simple stack frame' do
    result = Stacky::JStackframe.parse_line 'at java.lang.Object.wait(Object.java:485)'
    expect(result.type).to eq('java.lang.Object')
    expect(result.method).to eq('wait')
    expect(result.source).to eq('Object.java')
    expect(result.line).to eq(485)
    expect(result.locks).to eq([])
  end

  it 'should parse a stack line with a native method' do
    result = Stacky::JStackframe.parse_line 'at sun.misc.Unsafe.park(Native Method)'
    expect(result.type).to eq('sun.misc.Unsafe')
    expect(result.method).to eq('park')
    expect(result.source).to eq('Native Method')
    expect(result.line).to eq(nil)
    expect(result.locks).to eq([])
  end
end

describe Stacky::JStackframe, '#parse' do
  it 'should parse a single line' do
    result = Stacky::JStackframe.parse ['at java.lang.Object.wait(Object.java:485)']

    expect(result.size()).to eq(1)

    first_result = result.first()
    expect(first_result.type).to eq('java.lang.Object')
    expect(first_result.method).to eq('wait')
    expect(first_result.source).to eq('Object.java')
    expect(first_result.line).to eq(485)
    expect(first_result.locks).to eq([])
  end

  it 'should parse a stack with locks' do
    result = Stacky::JStackframe.parse [
                                           'at org.jivesoftware.smack.PacketWriter.nextPacket(PacketWriter.java:235)',
                                           '- locked <7ff1b2948> (a java.util.LinkedList)'                                       ]
    expect(result.size()).to eq(1)
    first_result = result.first()
    expect(first_result.type).to eq('org.jivesoftware.smack.PacketWriter')
    expect(first_result.method).to eq('nextPacket')
    expect(first_result.source).to eq('PacketWriter.java')
    expect(first_result.line).to eq(235)
    expect(first_result.locks.size()).to eq(1)

    first_lock = first_result.locks.first()
    expect(first_lock.locked?).to eq(true)
    expect(first_lock.lock_id).to eq('7ff1b2948')
  end

  it 'should parse a realistic example' do
    result = Stacky::JStackframe.parse(' at sun.nio.ch.KQueueArrayWrapper.kevent0(Native Method)
	at sun.nio.ch.KQueueArrayWrapper.poll(KQueueArrayWrapper.java:136)
	at sun.nio.ch.KQueueSelectorImpl.doSelect(KQueueSelectorImpl.java:69)
	at sun.nio.ch.SelectorImpl.lockAndDoSelect(SelectorImpl.java:69)
	- locked <7c4d02578> (a sun.nio.ch.Util$2)
	- locked <7c4d02568> (a java.util.Collections$UnmodifiableSet)
	- locked <7c4d01a70> (a sun.nio.ch.KQueueSelectorImpl)
	at sun.nio.ch.SelectorImpl.select(SelectorImpl.java:80)
	at sun.nio.ch.SelectorImpl.select(SelectorImpl.java:84)
	at org.jboss.netty.channel.socket.nio.NioServerBoss.select(NioServerBoss.java:163)
	at org.jboss.netty.channel.socket.nio.AbstractNioSelector.run(AbstractNioSelector.java:206)
	at org.jboss.netty.channel.socket.nio.NioServerBoss.run(NioServerBoss.java:42)
	at org.jboss.netty.util.ThreadRenamingRunnable.run(ThreadRenamingRunnable.java:108)
	at org.jboss.netty.util.internal.DeadLockProofWorker$1.run(DeadLockProofWorker.java:42)
	at com.intellij.openapi.application.impl.ApplicationImpl$8.run(ApplicationImpl.java:454)
	at java.util.concurrent.Executors$RunnableAdapter.call(Executors.java:439)
	at java.util.concurrent.FutureTask$Sync.innerRun(FutureTask.java:303)
	at java.util.concurrent.FutureTask.run(FutureTask.java:138)
	at java.util.concurrent.ThreadPoolExecutor$Worker.runTask(ThreadPoolExecutor.java:895)
	at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:918)
	at java.lang.Thread.run(Thread.java:680)
	at com.intellij.openapi.application.impl.ApplicationImpl$1$1.run(ApplicationImpl.java:152)'.lines)
    expect(result.size()).to eq(19)

  end
end