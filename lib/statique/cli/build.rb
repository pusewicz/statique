# frozen_string_literal: true

require "rack/mock"

class Statique
  class CLI
    class Build
      def initialize(options)
      end

      def run
        FileUtils.mkdir_p(Statique.destination)
        copy_public_assets
        build_pages

        Statique.ui.success "Done!"
      end

      private

      def build_pages
        Statique.discover.documents.each do |document|
          response = mock_request.get(document.path)
          if response.successful?
            destination = Statique.destination.join(File.extname(document.path).empty? ? "./#{document.path}/index.html" : "./#{document.path}")
            Statique.ui.info "Building page", path: document.path
            FileUtils.mkdir_p(destination.dirname)
            File.write(destination, response.body)
          else
            Statique.ui.error "Error building page", path: document.path, status: response.status
          end
        end
      end

      def mock_request
        @mock_request ||= Rack::MockRequest.new(Statique.app)
      end

      def copy_public_assets
        assets = Statique.paths.public.glob("**/*.*")
        Statique.ui.info "Copying public assets", assets:
          FileUtils.cp_r(assets, Statique.paths.destination)
      end
    end
  end
end
