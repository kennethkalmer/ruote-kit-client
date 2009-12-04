module RuoteKit
  module Client
    class Process < ::Hash

      # Last known agent used to populate this object
      attr_accessor :agent

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

      def method_missing( method_name, *args )
        if self.keys.include?( method_name.id2name )
          return self[ method_name.id2name ]
        end

        super
      end
    end
  end
end
