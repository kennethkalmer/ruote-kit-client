module RuoteKit
  module Client
    # Basic launch item
    class LaunchItem
      # A string process definition
      attr_accessor :definition

      # A URI to a remote process definition
      attr_accessor :uri

      # Hash of fields (default: empty hash)
      attr_reader :fields

      def initialize(definition_or_uri = nil, fields = {})
        case definition_or_uri
        when String
          begin
            @uri = URI.parse(definition_or_uri).to_s
          rescue URI::InvalidURIError
            @definition = definition_or_uri
          end
        when URI
          @uri = definition_or_uri.to_s
        else
          raise RuoteKit::Client::Exception, "first argument has to be String or URI"
        end
        self.fields = fields
      end

      def fields=( fields )
        raise ArgumentError, "fields must be a Hash" unless fields.kind_of?( Hash )

        @fields = fields
      end

      # Ensure a process definition or URI
      def valid?
        !( @definition.nil? && @uri.nil? )
      end

      def to_json
        hash = { 'fields' => @fields }
        hash['definition'] = @definition unless @definition.nil?
        hash['uri'] = @uri unless @uri.nil?

        hash.to_json
      end
    end
  end
end
