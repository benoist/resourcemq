lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
$: << 'lib'

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../frontend/config/environment", __FILE__)

require 'minitest/autorun'
require 'minitest/reporters'
require 'resource_mq'
require 'open3'

MiniTest::Reporters.use!

require 'benchmark'

#class ActiveResourceRailsBenchmark
#  def bench_hello_world
#    backend_rails_root = File.expand_path("../backend_rails", __FILE__)
#    #stdin, mstdout, stderr, wait_thr = Open3.popen3("bundle", "exec", "rails", "server", "--port=3000", :chdir => File.join(backend_rails_root, 'bin'))
#    output = ''
#    input = ''
#
#    xyz_pid = fork do
#      system("bundle", "exec", "rails", "server", "--port=3000",
#             :chdir => File.join(backend_rails_root, 'bin'),
#             :out   => output,
#             :err   => input)
#    end
#
#
#    #begin
#    #Timeout.timeout(15) do
#    print "Starting backend rails server..."
#    puts "--- before while"
#    loop do
#      print "."
#
#      #puts "> @mystderr.readlines"
#      #backend_server_errput = mystderr.readlines
#      #puts "ERRPUT: #{backend_server_errput}"
#      #puts "< @mystderr.readlines"
#
#      #puts "> @stdout.readlines"
#      #backend_server_errput = mystderr.readlines
#      #backend_server_output = mstdout.readlines
#      #puts "OUTPUT: #{backend_server_output}"
#      #puts "< @stdout.readlines"
#
#      puts "output = #{output}"
#
#      #break if backend_server_output.grep(/STARTED123/).any?
#      sleep 0.1
#      print "."
#    end
#
#    puts "--- end while"
#
#    if wait_thr.alive?
#      puts "it started baby!!"
#    else
#      puts "it DIDN't started!!"
#    end
#    #end
#    #rescue Timeout::Error
#    #  puts "KILLED!!!"
#    #  Process.kill(9, wait_thr.pid)
#    #end
#
#    puts "Waiting ..."
#    #@wait_thr.wait
#
#    #Process.kill("TERM", @wait_thr.pid) if @wait_thr.alive?
#
#    #puts "----"
#    #
#    #puts Benchmark.measure {
#    #  "a"*1_000_000
#    #}
#    #puts "----"
#  end
#end
#ActiveResourceRailsBenchmark.new.bench_hello_world

$stdout.sync = true
stdin, stdout, stderr, wait_thr = 1,1,1,1

Bundler.with_clean_env do
    backend_rails_root = File.expand_path("../backend_rails", __FILE__)
    system("bundle", "exec", "rails", "server", "--port=3000", "--environment=production", :chdir => File.join(backend_rails_root, 'bin'))

    loop do
      puts "."
      #puts "stdout: #{stdout}"
      #stdout.readline()

      #r, _, e = IO.select([stdout],[],[stderr],1)
      #puts "r: #{r}"
      #if r && r.size == 1
      #  puts "r.first.readlines: #{r.first.readlines}"
      #end
      #puts "e: #{e}"
      puts "."

      sleep 1
    end

    puts "EOF"
end


