# frozen_string_literal: true

require "set"

class Statique
  class Discover
    attr_reader :routes, :documents, :collections, :files

    SUPPORTED_EXTENSIONS = %w[
      slim
      md
      builder
    ].freeze

    GLOB = "**/*.{#{SUPPORTED_EXTENSIONS.join(",")}}"

    def initialize(root)
      @files = root.glob(GLOB).freeze
      @documents = {}
      @collections = Hashie::Mash.new { |hash, key| hash[key] = Set.new }
      @routes = {}

      discover!

      @documents.freeze
      @routes.freeze
      @collections.freeze
    end

    private

    def discover!
      @files.each do |file|
        document = Document.new(file)

        @documents[file], @routes[document.mount_point] = document, document

        Array(document.meta.collection).each do |collection|
          @collections[collection] << document
        end
      end
    end
  end
end
