# frozen_string_literal: true

require "front_matter_parser"
require "hashie"
require "pathname"
require "singleton"
require "uri"

::FrontMatterParser::SyntaxParser::Builder = FrontMatterParser::SyntaxParser::MultiLineComment["=begin", "=end"]

require_relative "statique/version"

$LOAD_PATH.unshift(File.expand_path("..", __FILE__))

class Statique
  class Error < StandardError; end

  autoload :App, "statique/app"
  autoload :Discover, "statique/discover"
  autoload :Document, "statique/document"
  autoload :Mode, "statique/mode"

  class << self
    def app
      @app ||= App.freeze.app
    end

    def discover
      @discover ||= Discover.new(content)
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

    def public
      @public ||= pwd.join("public").freeze
    end

    def public?
      public.directory?
    end

    def content
      @content ||= pwd.join("content").freeze
    end

    def content?
      content.directory?
    end

    def layouts
      @layouts ||= pwd.join("layouts").freeze
    end

    def layouts?
      layouts.directory?
    end

    def assets
      @assets ||= pwd.join("assets").freeze
    end

    def assets?
      assets.directory?
    end

    def destination
      @destination ||= pwd.join("dist").freeze
    end

    def destination?
      destination.directory?
    end

    def root_url
      @root_url ||= "/"
    end

    def url(document)
      File.join(root_url, document.path)
    end
  end
end
