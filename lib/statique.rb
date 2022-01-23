# frozen_string_literal: true

require "front_matter_parser"
require "hashie"
require "pathname"
require "singleton"
require "uri"
require "tty-logger"
require "pagy"
require "pagy/extras/array"
require "dry-configurable"

::FrontMatterParser::SyntaxParser::Builder = FrontMatterParser::SyntaxParser::MultiLineComment["=begin", "=end"]

require_relative "statique/version"
require_relative "statique/discover"
require_relative "statique/document"
require_relative "statique/mode"

$LOAD_PATH.unshift(File.expand_path("..", __FILE__))

class Statique
  extend Dry::Configurable
  class Error < StandardError; end

  setting :paths, reader: true do
    setting :pwd, default: Pathname.pwd, constructor: -> { Pathname(_1) }
    setting :public, default: Pathname.pwd.join("public"), constructor: -> { Statique.pwd.join(_1) }
    setting :content, default: Pathname.pwd.join("content"), constructor: -> { Statique.pwd.join(_1) }
    setting :layouts, default: Pathname.pwd.join("layouts"), constructor: -> { Statique.pwd.join(_1) }
    setting :assets, default: Pathname.pwd.join("assets"), constructor: -> { Statique.pwd.join(_1) }
    setting :destination, default: Pathname.pwd.join("dist"), constructor: -> { Statique.pwd.join(_1) }
  end
  setting :root_url, default: "/", reader: true

  class << self
    def app
      @app ||= App.freeze.app
    end

    def discover
      @discover ||= Discover.new(paths.content)
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

    def url(document)
      File.join(root_url, document.path)
    end
  end
end
