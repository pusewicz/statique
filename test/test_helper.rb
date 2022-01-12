# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "statique"

require "minitest/autorun"
require "minitest/around/spec"

require_relative "support/helpers"

Minitest::Test.send(:include, Statique::Support::Helpers)

Minitest.autorun
