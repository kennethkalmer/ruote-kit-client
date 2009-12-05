module RuoteKit
  module Client
    module HashExtensions

      def initialize( constructor = {} )
        if constructor.is_a?( Hash )
          super()
          update( constructor )
        else
          super
        end
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
