module RuoteKit
  module Client
    module EmbeddedAgent

      def agent=( agent )
        @agent = agent
      end

      def agent
        raise RuoteKit::Client::Exception, "agent not set for #{self}" if @agent.nil?

        @agent
      end
    end
  end
end
