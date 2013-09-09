test = File.expand_path('../test', __FILE__)
$LOAD_PATH.unshift(test) unless $LOAD_PATH.include?(test)
$: << 'test'

require 'test_helper'

Dir['./**/*_test.rb'].each do |test_file|
  require test_file
end
