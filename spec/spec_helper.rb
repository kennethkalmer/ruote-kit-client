require 'rubygems'
gem 'rspec'
require 'spec'

require 'mocha'
require 'fileutils'

require 'json'

$:.unshift( File.dirname(__FILE__) + '/../lib' )
require 'ruote-kit/client'

Spec::Runner.configure do |config|
  # == Mock Framework
  #
  # RSpec uses it's own mocking framework by default. If you prefer to
  # use mocha, flexmock or RR, uncomment the appropriate line:
  #
  config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
end

def mock_request( agent, method, path, body, options, response )
  if body
    agent.send(:jig).expects( method ).with( path, body, options ).returns( response )
  else
    agent.send(:jig).expects( method ).with( path, options ).returns( response )
  end
end
