module RuoteKit
  module Client
    class Expression < ::Hash
      include EmbeddedAgent
      include HashExtensions

      def wfid
        self['fei']['wfid']
      end

      def expid
        self['fei']['expid']
      end

      def workitem
        agent.find_workitem( self.wfid, self.expid )
      end

      def cancel!
        agent.cancel_expression( self )
      end

      def kill!
        agent.kill_expression( self )
      end
    end
  end
end