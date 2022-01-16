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
        Statique.ui.info "Starting server on port #{@port}"
        events = Puma::Events.new($stdout, $stderr)
        @server = Puma::Server.new App.freeze.app, events
        @server.add_tcp_listener("127.0.0.1", @port)
        @server.run(@background)
      end

      def stop
        Statique.ui.info "Stopping server on port #{@port}"
        @server.stop(true)
      end
    end
  end
end
