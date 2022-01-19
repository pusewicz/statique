# frozen_string_literal: true

require "pathname"

require_relative "statique/version"

libx = File.expand_path("..", __FILE__)
$LOAD_PATH.unshift(libx) unless $LOAD_PATH.include?(libx)

module Statique
  class Error < StandardError; end

  autoload :App, "statique/app"
  autoload :Discover, "statique/discover"
  autoload :Document, "statique/document"
  autoload :Mode, "statique/mode"

  class << self
    def version
      VERSION
    end

    def mode
      @mode ||= Mode.new
    end

    def discover
      @discover ||= Discover.new(Statique.content)
    end

    def ui
      @ui ||= TTY::Logger.new(output: $stdout)
    end

    def app
      @app ||= begin
        app = App
        app.freeze.app
      end
    end

    def pwd
      @pwd ||= Pathname.pwd
    end

    def public
      @public ||= pwd.join("public")
    end

    def public?
      public.directory?
    end

    def content
      @content ||= pwd.join("content")
    end

    def content?
      content.directory?
    end

    def layouts
      @layouts ||= pwd.join("layouts")
    end

    def layouts?
      layouts.directory?
    end

    def assets
      @assets ||= pwd.join("assets")
    end

    def assets?
      assets.directory?
    end

    def destination
      @destination ||= pwd.join("destination")
    end

    def destination?
      destination.directory?
    end
  end
end
