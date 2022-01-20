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
      @root = root
      @documents = {}
      @collections = Hashie::Mash.new { |hash, key| hash[key] = Set.new }
      @routes = {}

      discover_files!
      discover!

      statique.mode.build do
        @files.freeze
        @documents.freeze
        @routes.freeze
        @collections.freeze
      end

      watch_for_changes if statique.mode.server?
    end

    private

    def discover_files!
      @files = @root.glob(GLOB)
    end

    def discover!
      @files.each do |file|
        process(file)
      end
    end

    def process(file)
      document = Document.new(file)

      documents[file.to_s], routes[document.mount_point] = document, document

      Array(document.meta.collection).each do |collection|
        collections[collection] << document
      end
    end

    def watch_for_changes
      require "filewatcher"

      @filewatcher = Filewatcher.new([statique.content, statique.layouts])
      @filewatcher_thread = Thread.new(@filewatcher) do |watcher|
        watcher.watch do |file, event|
          Statique.ui.debug "File change event", file: file, event: event
          discover_files!
          path = Pathname.new(file)
          remove_file!(path)
          process(path) unless event == :deleted
        end
      end
      Statique.ui.debug "Started file watcher", filewatcher: @filewatcher, thread: @filewatcher_thread

      at_exit do
        Statique.ui.debug "Closing file watcher", thread: @filewatcher_thread
        @filewatcher.stop
        @filewatcher.finalize
        @filewatcher_thread.join
      end
    end

    def remove_file!(path)
      document = documents[path.to_s]

      collections.each_value do |collection|
        # TODO: See if set can index by some particular property to avoid looping
        collection.delete_if { _1.file == path }
      end
      documents.delete(path.to_s)

      if document
        routes.delete(document.mount_point)
      end
    end

    def statique
      Statique.instance
    end
  end
end
