require "rack"

class Statique
  class CLI
    class Server
      def initialize(port: 3000)
        @port = port
      end

      class LoggerWrapper
        def <<(msg)
          method, uri, status = msg.chomp.split(":")
          Statique.ui.info "#{method} #{uri}", status: status.to_i
        end
      end

      def run
        Statique.ui.info "Starting server", port: @port

        Rack::Handler::WEBrick.run(Statique.instance.app,
          Port: @port,
          Host: "localhost",
          Logger: Statique.ui,
          AccessLog: [[LoggerWrapper.new, "%m:%U:%s"]])
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
