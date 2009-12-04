require 'rubygems'
gem 'rspec'
require 'spec'

require 'mocha'
require 'fileutils'

$:.unshift( File.dirname(__FILE__) + '/../lib' )
require 'ruote-kit/client'

Spec::Runner.configure do |config|
  # == Mock Framework
  #
  # RSpec uses it's own mocking framework by default. If you prefer to
  # use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
end
