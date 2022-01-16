# frozen_string_literal: true

require "pathname"

module Statique
  class Error < StandardError; end

  class << self
    attr_accessor :ui

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
