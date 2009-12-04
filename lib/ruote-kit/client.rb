require 'rufus-jig'

module RuoteKit
  # Shortcut to RuoteKit::Client::Agent
  def self.Client( url )
    Client::Agent.new( url )
  end

  module Client

    VERSION = '0.0.0'

    autoload :Agent, 'ruote-kit/client/agent'
  end
end
