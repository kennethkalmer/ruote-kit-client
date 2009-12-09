require 'rufus-jig'

module RuoteKit
  # Shortcut to RuoteKit::Client::Agent
  def self.Client( url )
    Client::Agent.new( url )
  end

  module Client

    VERSION = '0.0.0'

    autoload :Exception, 'ruote-kit/client/exception'
    autoload :Agent, 'ruote-kit/client/agent'
    autoload :LaunchItem, 'ruote-kit/client/launch_item'
    autoload :Process, 'ruote-kit/client/process'
    autoload :EmbeddedAgent, 'ruote-kit/client/embedded_agent'
    autoload :HashExtensions, 'ruote-kit/client/hash_extensions'
    autoload :Workitem, 'ruote-kit/client/workitem'
    autoload :Expression, 'ruote-kit/client/expression'
  end
end
