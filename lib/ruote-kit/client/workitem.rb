module RuoteKit
  module Client
    class Workitem < ::Hash

      include EmbeddedAgent
      include HashExtensions

      def process
        agent.find_process(fei['wfid'])
      end
    end
  end
end
