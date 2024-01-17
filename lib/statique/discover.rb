# frozen_string_literal: true

require "set"

class Statique
  class Discover
    attr_reader :documents, :collections, :files

    SUPPORTED_EXTENSIONS = %w[
      slim
      md
      builder
    ].freeze

    GLOB = "**/*.{#{SUPPORTED_EXTENSIONS.join(",")}}"

    def initialize(root, statique)
      @root = root
      @documents = []
      @collections = Hashie::Mash.new { |hash, key| hash[key] = Set.new }
      @statique = statique

      discover_files!
      discover!

      @statique.mode.build do
        @files.freeze
        @documents.freeze
        @collections.freeze
      end
    end

    private

    def discover_files!
      @files = @root.glob(GLOB)
    ensure
      @statique.ui.debug "Discovered files", count: @files.size
    end

    def discover!
      @files.each do |file|
        process(file)
      end
    end

    def process(file)
      document = Document.new(file, @statique)

      documents << document

      Array(document.meta.collection).each do |collection|
        collections[collection] << document
      end
    end

    def remove_file!(path)
      documents.delete_if { _1.file == path }
      collections.each_value do |collection|
        # TODO: See if set can index by some particular property to avoid looping
        collection.delete_if { _1.file == path }
      end
    end
  end
end
