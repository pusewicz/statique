# frozen_string_literal: true

require "set"

module Statique
  class Discover
    attr_reader :routes, :documents, :collections, :files

    def initialize(root)
      @files = root.glob("**/*.{slim,md}")
      @documents = {}
      @collections = Hash.new { |hash, key| hash[key] = Set.new }
      @routes = {}

      discover!
    end

    private

    def discover!
      @files.each do |file|
        document = Document.new(file)

        @documents[file], @routes[document.mount_point] = document, document

        @collections[document.meta.collection] << document
      end
    end
  end
end
