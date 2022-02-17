# frozen_string_literal: true

require "fileutils"
require "benchmark"
require "memo_wise"

class Statique
  class CLI
    class Build
      prepend MemoWise

      def initialize(options, statique)
        Thread.abort_on_exception = true
        @statique = statique
        @queue = Queue.new
      end

      def run
        require "statique/app"
        time = Benchmark.realtime do
          create_directory(@statique.configuration.paths.destination)
          copy_public_assets
          build_pages
        end

        @statique.ui.success "Done!", time: time
      end

      private

      def build_pages
        @statique.discover.documents.each do |document|
          @queue << document.path

          if (pages = document.pagination_pages)
            (2..pages).each { @queue << File.join(document.path, "/page/#{_1}") if _1 > 1 }
          end
        end

        @threads = Array.new(8) do |n|
          Thread.new("worker-#{n}") do
            until @queue.empty?
              path = @queue.pop
              response = mock_request.get(path)
              if response.successful?
                destination = @statique.configuration.paths.destination.join(File.extname(path).empty? ? "./#{path}/index.html" : "./#{path}")
                @statique.ui.info "Building page", path: path
                create_directory(destination.dirname)
                File.write(destination, response.body)
              else
                @statique.ui.error "Error building page", path: path, status: response.status
              end
            end
          end
        end

        @threads.each(&:join)
      end

      def mock_request
        @mock_request ||= Rack::MockRequest.new(Statique::App.freeze)
      end

      def copy_public_assets
        assets = @statique.configuration.paths.public.glob("**/*.*")
        @statique.ui.info "Copying public assets", assets:
          FileUtils.cp_r(assets, @statique.configuration.paths.destination)
      end

      private

      def create_directory(dir)
        FileUtils.mkdir_p(dir)
      end
      memo_wise :create_directory
    end
  end
end
