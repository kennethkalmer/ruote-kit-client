module RuoteKit
  module Client

    # This wrapper around rufus-jig
    class Agent

      # URL to a running ruote-kit
      attr_reader :url

      def initialize( url )
        @url = url
      end
    end
  end
end
