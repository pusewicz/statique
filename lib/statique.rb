# frozen_string_literal: true

require "pathname"
require "singleton"

require_relative "statique/version"

libx = File.expand_path("..", __FILE__)
$LOAD_PATH.unshift(libx) unless $LOAD_PATH.include?(libx)

class Statique
  include Singleton

  class Error < StandardError; end

  autoload :App, "statique/app"
  autoload :Discover, "statique/discover"
  autoload :Document, "statique/document"
  autoload :Mode, "statique/mode"

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
    @pwd ||= Pathname.pwd.freeze # TODO: Freeze?
  end

  def version
    VERSION
  end

  def self.ui
    @ui ||= TTY::Logger.new(output: $stdout)
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
    @destination ||= pwd.join("destination").freeze
  end

  def destination?
    destination.directory?
  end
  end
end
