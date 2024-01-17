# frozen_string_literal: true

require "optparse"

class Statique
  class CLI
    autoload :Build, "statique/cli/build"
    autoload :Init, "statique/cli/init"

    def initialize(argv)
      @argv = argv
    end

    def run
      subcommand = @argv.shift

      case subcommand
      when "init"
        init
      when "build"
        build
      when "version", "-v", "--version"
        version
      when nil
        # Print help and exit
        puts <<~HELP
          Usage: statique <command> [<args>]

          Available commands:

            init    Initialise a new Statique website
            build   Build a Statique website
            version Print Statique version information

          Options:
            -h, --help     Print this help message and exit
            -v, --version  Print Statique version information
        HELP

        exit
      else
        puts "Unknown command: #{subcommand}"
        exit 1
      end
    end

    def init
      name = @argv.shift
      if name.nil?
        puts "Please specify a directory name, e.g. #{$0} init my-website"

        exit
      end
      Init.new(name).run
    end

    def build
      Build.new(statique).run
    end

    def version
      puts "Statique v#{Statique::VERSION}"
    end

    private

    def statique
      Statique.instance
    end
  end
end
