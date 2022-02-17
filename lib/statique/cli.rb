# frozen_string_literal: true

require "thor"

class Statique
  class CLI < Thor
    autoload :Server, "statique/cli/server"
    autoload :Build, "statique/cli/build"
    autoload :Init, "statique/cli/init"

    package_name "Statique"

    COMMAND_ALIASES = {
      "version" => %w[-v --version]
    }.freeze

    def initialize(*args)
      super
    end

    def self.exit_on_failure?
      true
    end

    def self.aliases_for(command_name)
      COMMAND_ALIASES.select { |k, _| k == command_name }.invert
    end

    desc "init", "Initialize new Statique website"
    argument :name, optional: true, desc: "Name of the directory to initialise the Statique website in"
    def init
      Init.new(name).run
    end

    desc "server", "Start Statique server"
    def server
      statique.mode.server!
      Server.new(statique).run
    end

    desc "build", "Build Statique site"
    def build
      statique.mode.build!
      Build.new(options.dup, statique).run
    end

    desc "version", "Prints the statique's version information"
    def version
      Statique.ui.info "Statique v#{Statique::VERSION}"
    end

    map aliases_for("version")

    private

    def statique
      Statique.instance
    end
  end
end
