module RuoteKit
  module Client
    class Process < ::Hash

      include EmbeddedAgent
      include HashExtensions

      def name
        self['definition_name']
      end

      def revision
        self['definition_revision']
      end

      # Cancel the process
      def cancel!
        agent.cancel_process( wfid )
      end

      # Kill the process
      def kill!
        agent.kill_process( wfid )
      end

      def workitems(options = {})
        agent.workitems({:process => self}.merge(options))
      end

      def expressions
        agent.expressions( self )
      end
    end
  end
end
