require "puma"
require "puma/configuration"
require "puma/launcher"

require_relative "../app"

module Statique
  class CLI
    class Server
      def initialize(port: 3000, background: true)
        @port = port
        @background = background
      end

      def run
        Statique.ui.info "Starting server", port: @port, background: @background
        events = Puma::Events.new(EventStream.new(:info), EventStream.new(:warn))
        @server = Puma::Server.new App.freeze.app, events
        @server.add_tcp_listener("127.0.0.1", @port)
        @server.run(@background)
      end

      def stop
        Statique.ui.info "Stopping server"
        @server.stop(true)
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
