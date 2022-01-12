require "thor"
require "tty-logger"

module Statique
  class CLI < Thor
    package_name "Statique"

    COMMAND_ALIASES = {
      "version" => %w[-v --version]
    }.freeze

    def initialize(*args)
      super
    ensure
      Statique.ui = TTY::Logger.new(output: $stdout)
    end

    def self.aliases_for(command_name)
      COMMAND_ALIASES.select { |k, _| k == command_name }.invert
    end

    desc "version", "Prints the statique's version information"
    def version
      Statique.ui.info "Statique v#{Statique::VERSION}"
    end

    map aliases_for("version")
  end
end
