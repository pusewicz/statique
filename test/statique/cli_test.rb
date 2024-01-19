# frozen_string_literal: true

require "test_helper"

class TestCLI < Minitest::Spec
  around do |test|
    Dir.mktmpdir("statique") do |dir|
      @dir = Pathname(dir)
      test.call
    end
  end

  describe "version" do
    it "returns version number with `version`" do
      statique "version"
      expect(out).must_include "Statique v#{Statique::VERSION}"
    end

    it "returns version number with `-v`" do
      statique "-v"
      expect(out).must_include "Statique v#{Statique::VERSION}"
    end

    it "returns version number with `--version`" do
      statique "--version"
      expect(out).must_include "Statique v#{Statique::VERSION}"
    end
  end

  describe "init" do
    it "creates the files structure" do
      statique "init my-site"

      assert_predicate @dir.join("my-site/assets/css/app.css"), :exist?
      assert_predicate @dir.join("my-site/assets/js/app.js"), :exist?
      assert_predicate @dir.join("my-site/public/robots.txt"), :exist?
      assert_predicate @dir.join("my-site/content/index.md"), :exist?
      assert_predicate @dir.join("my-site/layouts/layout.slim"), :exist?
    end
  end

  describe "build" do
    it "builds the website" do
      statique "init my-site"

      statique "build", dir: @dir.join("my-site")

      assert_predicate @dir.join("my-site/dist/index.html"), :exist?
      assert_predicate @dir.join("my-site/dist/robots.txt"), :exist?

      assert_includes @dir.join("my-site/dist/index.html").read, "<footer>Made with Statique v#{Statique::VERSION}</footer>"
    end
  end

  describe "invalid command" do
    it "returns a non-zero exit code" do
      statique "i-do-not-exist", raise_error: false
      expect(last_command.failure?).must_equal true
    end
  end
end
