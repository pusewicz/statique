# frozen_string_literal: true

require "test_helper"

class TestMode < Minitest::Spec
  it "initialize in server mode by default" do
    @mode = Statique::Mode.new
    expect(@mode.server?).must_equal true
  end

  it "accepts server mode" do
    @mode = Statique::Mode.new("server")
    expect(@mode.server?).must_equal true
  end

  it "accepts build mode" do
    @mode = Statique::Mode.new("build")
    expect(@mode.build?).must_equal true
  end

  it "allows switching mode to build" do
    @mode = Statique::Mode.new("server")
    @mode.build!
    expect(@mode.build?).must_equal true
    expect(@mode.server?).must_equal false
  end

  it "allows switching mode to server" do
    @mode = Statique::Mode.new("build")
    @mode.server!
    expect(@mode.server?).must_equal true
    expect(@mode.build?).must_equal false
  end

  it "raises an exception on invalid mode" do
    expect { Statique::Mode.new("non-existent") }.must_raise ArgumentError
  end

  describe "#server" do
    it "executes block if mode is server" do
      executed = false
      @mode = Statique::Mode.new("server")
      @mode.server { executed = true }
      expect(executed).must_equal true
    end

    it "does not execute block if mode is not server" do
      executed = false
      @mode = Statique::Mode.new("build")
      @mode.server { executed = true }
      expect(executed).must_equal false
    end
  end

  describe "#build" do
    it "executes block if mode is build" do
      executed = false
      @mode = Statique::Mode.new("build")
      @mode.build { executed = true }
      expect(executed).must_equal true
    end

    it "does not execute block if mode is not build" do
      executed = false
      @mode = Statique::Mode.new("server")
      @mode.build { executed = true }
      expect(executed).must_equal false
    end
  end
end
