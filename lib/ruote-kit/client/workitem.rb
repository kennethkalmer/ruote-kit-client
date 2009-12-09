module RuoteKit
  module Client
    class Workitem < ::Hash

      include EmbeddedAgent
      include HashExtensions

      def process
        agent.find_process(fei['wfid'])
      end

      def save
        agent.update_workitem(self)
      end

      def proceed
        agent.proceed_workitem(self)
      end

      def expression
        agent.find_expression(fei['wfid'], fei['expid'])
      end
    end
  end
end
