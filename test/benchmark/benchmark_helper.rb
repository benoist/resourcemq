lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
$: << 'lib'

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../frontend/config/environment", __FILE__)

require 'resource_mq'
#require 'benchmark'

#output                                                                          = `wrk -d 10s  http://127.0.0.1:3000/products.json`
#lines                                                                           = output.split('\n')
#latency_arr                                                                     = lines.grep(/    Latency/).split
# Thread Stats   Avg     Stdev        Max       +/- Stdev
# ["Latency"    ,"378.95ms" ,"507.94ms"  ,"1.13s"  ,"68.45%"]
# ["Req/Sec"    , "84.32"   ,"61.05"     ,"194.00" ,"61.90%"]
#req_sec_label, req_sec_avg, req_sec_stdev, req_sec_max, req_sec_stdevpercentage = lines.grep(/    Req\/Sec/).first.split


require 'net/http'
require 'uri'

FRONTEND_URI      = ['frontend', URI.parse("http://127.0.0.1:3000/ready")]
BACKEND_RAILS_URI = ['backend_rails', URI.parse("http://127.0.0.1:3001/ready")]

def all_benchmark_apps_running?
  apps = [FRONTEND_URI, BACKEND_RAILS_URI]
  apps.each do |app_name, app_uri|
    response = ''
    http     = Net::HTTP.new(app_uri.host, app_uri.port)
    begin
      response = http.request(Net::HTTP::Get.new(app_uri.request_uri)).body
      puts "app_uri #{app_name} : '#{response}'"
    rescue Errno::ECONNREFUSED
      puts "#{app_name} connection refused"
    end
    puts "== #{response} != #{app_name} ready"
    return false if (response != "#{app_name} ready")
  end
  true
end

puts "starting foreman which starts all benchmark apps..."
foreman_thread_pid = fork do
  Bundler.with_clean_env do
    foreman_pid = Process.spawn("foreman", "start", chdir: File.expand_path("..", __FILE__))
    Signal.trap("TERM") { Process.kill("INT", foreman_pid) }
    Process.wait(foreman_pid)
  end
end

puts "are all benchmark apps running?"
while not all_benchmark_apps_running? do
  sleep 0.1
  print "."
end

#puts 'warming up...'
#output      = `wrk -d 2s  http://127.0.0.1:3000/products.json`

puts 'running directly against backend_rails...'
output      = `wrk -d 5s  http://127.0.0.1:3001/products.json`
puts "output:"
puts output

puts 'running against backend_rails...'
output      = `wrk -d 5s  http://127.0.0.1:3000/products.json`
lines       = output.split('\n')
latency_arr = lines.grep(/    Latency/).split
puts "output:"
puts output
puts

puts "KILLING foreman..."
kill_output = Process.kill("TERM", foreman_thread_pid)
Process.wait(foreman_thread_pid)
