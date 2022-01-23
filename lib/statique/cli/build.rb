# frozen_string_literal: true

require "rack/mock"
require "benchmark"
require "statique/app"

class Statique
  class CLI
    class Build
      def initialize(options)
        Thread.abort_on_exception = true
        @queue = Statique.build_queue
      end

      def run
        time = Benchmark.realtime do
          FileUtils.mkdir_p(Statique.paths.destination)
          copy_public_assets
          build_pages
        end

        Statique.ui.success "Done!", time: time
      end

      private

      def build_pages
        Statique.discover.documents.each do |document|
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
                destination = Statique.paths.destination.join(File.extname(path).empty? ? "./#{path}/index.html" : "./#{path}")
                Statique.ui.info "Building page", path: path
                FileUtils.mkdir_p(destination.dirname)
                File.write(destination, response.body)
              else
                Statique.ui.error "Error building page", path: document.path, status: response.status
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
        assets = Statique.paths.public.glob("**/*.*")
        Statique.ui.info "Copying public assets", assets:
          FileUtils.cp_r(assets, Statique.paths.destination)
      end
    end
  end
end
