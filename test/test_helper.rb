# frozen_string_literal: true

# Don't generate coverage if we're running a single test
unless ENV["TEST"]
  require "simplecov"

  SimpleCov.start do
    enable_coverage :branch
  end
end

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "statique"
require "minitest/autorun"
require "minitest/around/spec"

require_relative "support/helpers"

Minitest::Test.send(:include, Statique::Support::Helpers)

Minitest.autorun
