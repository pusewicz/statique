# frozen_string_literal: true

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
  end
end
