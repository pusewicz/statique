# frozen_string_literal: true

require "test_helper"

class TestCLI < Minitest::Spec
  around do |test|
    Dir.mktmpdir("statique") do |dir|
      @dir = dir
      test.call
    end
  end

  describe "version" do
    it "returns version number with `version`" do
      statique "version"
      expect(out).must_include "Statique v0.1.0"
    end

    it "returns version number with `-v`" do
      statique "-v"
      expect(out).must_include "Statique v0.1.0"
    end

    it "returns version number with `--version`" do
      statique "--version"
      expect(out).must_include "Statique v0.1.0"
    end
  end

  describe "invalid command" do
    it "returns a non-zero exit code" do
      statique "i-do-not-exist", raise_error: false
      expect(last_command.failure?).must_equal true
    end
  end
end
