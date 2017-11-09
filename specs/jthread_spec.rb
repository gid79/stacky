
require_relative 'spec_helper'

describe Stacky::JThread, 'parse' do
  
  it 'should extract the first line details' do
    result = Stacky::JThread.parse ['"Thread-16" daemon prio=4 tid=10ee26800 nid=0x12b7a4000 waiting on condition [12b7a3000]']
    expect(result.name).to eq('Thread-16')
    expect(result.daemon).to be true
    expect(result.tid).to eq('10ee26800')
    expect(result.nid).to eq('0x12b7a4000'    )
    expect(result.prio).to eq(4)
  end
  
  it 'should parse without the daemon flag' do
    result = Stacky::JThread.parse ['"Smack Packet Writer" prio=4 tid=10ea07000 nid=0x12c8fe000 in Object.wait() [12c8fd000]']
    expect(result.daemon).to be false
  end
  
  context 'parse the thread state' do
    it 'when the description is not present' do
      result = Stacky::JThread.parse ['', 'java.lang.Thread.State: RUNNABLE']
      expect(result.state).to eq('RUNNABLE')
    end
    it 'when the description is present' do
      result = Stacky::JThread.parse ['', 'java.lang.Thread.State: WAITING (on object monitor)']
      expect(result.state).to eq('WAITING')
      expect(result.state_description).to eq('on object monitor')
    end
  end

  context 'parse the stackframes' do
    it 'when stackframes present should parse into #stackframes' do
      result = Stacky::JThread.parse '"New I/O server boss #2" prio=4 tid=1142a5000 nid=0x125bcc000 runnable [125bcb000]
   java.lang.Thread.State: RUNNABLE
	at sun.nio.ch.KQueueArrayWrapper.kevent0(Native Method)
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
	at com.intellij.openapi.application.impl.ApplicationImpl$1$1.run(ApplicationImpl.java:152)'.lines.to_a
      expect(result.stackframes.size).to eq(19)
      expect(result.state).to eq('RUNNABLE')
    end
  end
  
end