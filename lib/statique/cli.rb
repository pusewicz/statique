require "thor"
require "tty-logger"

module Statique
  class CLI < Thor
    autoload :Server, "statique/cli/server"
    autoload :Build, "statique/cli/build"

    package_name "Statique"

    COMMAND_ALIASES = {
      "version" => %w[-v --version]
    }.freeze

    def initialize(*args)
      super
    end

    def self.aliases_for(command_name)
      COMMAND_ALIASES.select { |k, _| k == command_name }.invert
    end

    desc "server", "Start Statique server"
    def server
      Statique.mode.server!
      Server.new.run
    end

    desc "build", "Build Statique site"
    def build
      Statique.mode.build!
      Build.new(options.dup).run
    end

    desc "version", "Prints the statique's version information"
    def version
      Statique.ui.info "Statique v#{Statique::VERSION}"
    end

    map aliases_for("version")
  end
end
