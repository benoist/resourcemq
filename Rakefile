require "bundler/gem_tasks"
require 'rake'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs.push 'lib'
  t.libs.push 'test'
  t.pattern = 'test/**/*_test.rb'
end

desc "benchmark"
task :benchmark do
  require File.expand_path("../test/benchmark/benchmark_helper", __FILE__)
  puts "hello world! #{Frontend::Application}"
end
