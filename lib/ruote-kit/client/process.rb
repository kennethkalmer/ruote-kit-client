module RuoteKit
  module Client
    class Process < ::Hash

      include EmbeddedAgent

      def initialize( constructor = {} )
        if constructor.is_a?( Hash )
          super()
          update( constructor )
        else
          super
        end
      end

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

      def method_missing( method_name, *args )
        if self.keys.include?( method_name.id2name )
          return self[ method_name.id2name ]
        end

        super
      end
    end
  end
end
