# frozen_string_literal: true

module Statique
  class Discover
    def initialize(root)
      @root = root
    end

    def each
      @files ||= @root.glob("**/*.{slim,md}")
      @files.each do |path|
        yield Route.new(path)
      end
    end
  end
end
