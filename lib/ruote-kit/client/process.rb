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

    end
  end
end
