# frozen_string_literal: true

require_relative "statique/version"

require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.setup

module Statique
  class Error < StandardError; end

  class << self
    attr_accessor :ui
  end
end
