require "rack"

class Statique
  class CLI
    class Server
      class LoggerWrapper
        def <<(msg)
          method, uri, status, time, content_type = msg.chomp.split(":")
          log(:info, "#{method} #{uri}", status: status.to_i, time: time.to_f, content_type:)
        end

        def log(type, msg, attrs = {})
          Statique.ui.public_send(type, msg, attrs.merge(app: "webrick"))
        end

        %i[unknown fatal error warn info debug].each do |type|
          define_method(type) do |msg|
            log(type, msg)
          end

          define_method(:"#{type}?") do
            Statique.ui.compare_levels(Statique.ui.class.config.level, type.to_sym) != :lt
          end
        end
      end

      def initialize(port: 3000)
        @port = port
      end

      def run
        Statique.ui.info "Starting server", port: @port

        logger = LoggerWrapper.new

        Rack::Handler::WEBrick.run(Statique.instance.app,
          Port: @port,
          Host: "localhost",
          Logger: logger,
          AccessLog: [[logger, "%m:%U:%s:%T:%{Content-Type}o"]])
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
