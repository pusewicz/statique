require "puma"
require "puma/configuration"
require "puma/launcher"

module Statique
  class CLI
    class Server
      def initialize(options)
      end

      def run
        config = Puma::Configuration.new({}) do |user_config, _|
          user_config.app(App.freeze.app)
          user_config.port(3000)
        end

        Puma::Launcher.new(config).run
      end
    end
  end
end
