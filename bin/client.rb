#!/usr/bin/env ruby
lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'librmdp'
require 'resource_mq'
require 'benchmark'

Dir['spec/dummy/app/models/**/*.rb'].each { |f| require File.expand_path("../../#{f}", __FILE__) }
Dir['spec/dummy/app/messages/**/*.rb'].each { |f| require File.expand_path("../../#{f}", __FILE__) }

client   = Majordomo::Client.new('tcp://0.0.0.0:5555')
requests = 1000

start = Time.now
requests.times do
  ProductMessages::Index.new
  request = ResourceMQ::Request.new(service_name: 'products', method_name: 'index')

  request.encode(raw_request = '')

  client.send_message('echo', raw_request)
end

requests.times do
  response = client.receive_message

  response = ResourceMQ::Response.decode(response.first)

  @last = ProductMessages::List.decode(response.response_proto)
end
puts @last.inspect

duration = Time.now - start
rps = requests / duration

puts "RPS: #{rps} duration: #{duration}"
