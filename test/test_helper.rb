lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
$: << 'lib'

require 'minitest/autorun'
require 'minitest/reporters'
require 'resourcemq'

MiniTest::Reporters.use!
