require 'rho'
module Profiler 
  def benchmark(msg = "Benchmark started")
    RhoLog.new.info('', '')
    RhoLog.new.info('profile', '********************************************************')
    RhoLog.new.info('profile', msg)
    RhoLog.new.info('profile', caller(0)[1])
    start = Time.now
    yield
    elapsed = Time.now - start
    RhoLog.new.info('profile', "Elapsed time: #{elapsed}")
    RhoLog.new.info('profile', '********************************************************')
    RhoLog.new.info('', '')
  end
end

