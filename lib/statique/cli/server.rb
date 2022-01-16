require_relative "../app"

module Statique
  class CLI
    class Server
      def initialize(port: 3000)
        @port = port
      end

      def run
        Statique.ui.info "Starting server", port: @port

        Rack::Handler::WEBrick.run(Statique.app, Port: @port, Host: "localhost")
      end

      def stop
        Statique.ui.info "Stopping server"
        Rack::Handler::WEBrick.shutdown
      end

      class EventStream
        def initialize(type)
          @type = type
        end

        def puts(message)
          Statique.ui.public_send(@type, message)
        end

        def write(message)
          puts(message)
        end

        def sync
          true
        end
      end
    end
  end
end
