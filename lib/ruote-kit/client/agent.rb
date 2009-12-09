module RuoteKit
  module Client

    # This wrapper around rufus-jig
    class Agent

      # URL to a running ruote-kit
      attr_reader :url

      def initialize( url )
        @url = URI.parse( url )
      end

      # Launch the process specified in the #RuoteKit::Client::LaunchItem.
      # Returns a #RuoteKit::Client::Process instance of the newly launched process
      def launch_process( launch_item_or_definition_or_uri, fields = {} )
        launch_item = if launch_item_or_definition_or_uri.kind_of?(RuoteKit::Client::LaunchItem)
          launch_item_or_definition_or_uri
        else
          LaunchItem.new(launch_item_or_definition_or_uri, fields)
        end

        raise RuoteKit::Client::Exception, "Launch item not valid" unless launch_item.valid?

        response = jig.post(
          '/processes',
          launch_item.to_json,
          :content_type => 'application/json', :accept => 'application/json'
        )

        raise RuoteKit::Client::Exception, "Invalid response from ruote-kit" if response.nil? or response['process'].nil?

        Process.new(response['process'])
      end

      # Return the list of processes
      def processes
        response = jig.get('/processes', :accept => 'application/json')

        response['processes'].map { |p| Process.new(p) }.each { |p| p.agent = self }
      end

      # Cancel a process
      def cancel_process( wfid )
        jig.delete( "/processes/#{wfid}", :accept => 'application/json' )
      end

      # Kill a process
      def kill_process( wfid )
        jig.delete( "/processes/#{wfid}?_kill=1", :accept => 'application/json' )
      end

      def workitems( options = {} )
        path = "/workitems"

        query = []
        if options[:participant]
          parts = [ options[:participant] ].flatten
          query << "participant=" + parts.join(',')
        end

        path << "?" + query.join('&') unless query.empty?

        response = jig.get( path, :accept => 'application/json' )

        response['workitems'].map { |w| Workitem.new(w) }.each { |w| w.agent = self }
      end

      private

      def jig
        @jig ||= Rufus::Jig::Http.new( @url.host, @url.port )
      end
    end
  end
end
