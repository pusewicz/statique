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

      watch_for_changes if @statique.mode.server?
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

    def watch_for_changes
      require "filewatcher"

      @filewatcher = Filewatcher.new([@statique.configuration.paths.content, @statique.configuration.paths.layouts])
      @filewatcher_thread = Thread.new(@filewatcher) do |watcher|
        watcher.watch do |file, event|
          @statique.ui.debug "File change event", file: file, event: event
          discover_files!
          path = Pathname.new(file)
          remove_file!(path)
          process(path) unless event == :deleted
        end
      end
      @statique.ui.debug "Started file watcher", filewatcher: @filewatcher, thread: @filewatcher_thread

      at_exit do
        @statique.ui.debug "Closing file watcher", thread: @filewatcher_thread
        @filewatcher.stop
        @filewatcher.finalize
        @filewatcher_thread.join
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
