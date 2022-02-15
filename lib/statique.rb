# frozen_string_literal: true

require "front_matter_parser"
require "hashie"
require "pathname"
require "pagy"
require "rack"
require "tty-logger"

::FrontMatterParser::SyntaxParser::Builder = FrontMatterParser::SyntaxParser::MultiLineComment["=begin", "=end"]

$LOAD_PATH.unshift(File.expand_path("..", __FILE__))

require "statique/version"
require "statique/cli"
require "statique/mode"
require "statique/discover"
require "statique/document"

class Statique
  class Error < StandardError; end

  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def discover
      @discover ||= Discover.new(configuration.paths.content)
    end

    def mode
      @mode ||= Mode.new
    end

    def pwd
      @pwd ||= Pathname.pwd.freeze
    end

    def version
      VERSION
    end

    def ui
      @ui ||= TTY::Logger.new(output: $stdout) do |config|
        config.level = :debug if ENV["DEBUG"] == "true"
      end
    end

    def url(document_or_path)
      File.join(root_url, document_or_path.is_a?(Document) ? document_or_path.path : document_or_path)
    end

    def build_queue
      @build_queue ||= Queue.new
    end
  end
end
