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
    end
  end
end