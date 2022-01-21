# frozen_string_literal: true

require "rack/mock"

class Statique
  class CLI
    class Build
      def initialize(options)
      end

      def run
        copy_public_assets
        build_pages

        Statique.ui.success "Done!"
      end

      private

      def build_pages
        Statique.discover.routes.each do |path, file|
          response = mock_request.get(path)
          if response.successful?
            destination = Statique.destination.join(File.extname(path).empty? ? "./#{path}/index.html" : "./#{path}")
            Statique.ui.info "Building page", path: path.to_s
            FileUtils.mkdir_p(destination.dirname)
            File.write(destination, response.body)
          else
            Statique.ui.error "Error building page", path: path.to_s, status: response.status
          end
        end
      end

      def mock_request
        @mock_request ||= Rack::MockRequest.new(Statique.app)
      end

      def copy_public_assets
        assets = Statique.public.glob("**/*.*")
        Statique.ui.info "Copying public assets", assets:
        FileUtils.cp_r(assets, Statique.destination)
      end
    end
  end
end
