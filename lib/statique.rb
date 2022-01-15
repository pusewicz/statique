# frozen_string_literal: true

require "pathname"
require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect(
  "cli" => "CLI"
)
loader.setup

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
  end
end
