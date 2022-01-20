require "rack/mock"

class Statique
  class CLI
    class Build
      attr_reader :statique

      def initialize(options)
        @statique = Statique.instance
      end

      def run
        copy_public_assets
        build_pages

        Statique.ui.success "Done!"
      end

      private

      def build_pages
        statique.discover.routes.each do |path, file|
          response = mock_request.get(path)
          if response.successful?
            destination = statique.destination.join("./#{path}/index.html")
            Statique.ui.info "Building page", path: path.to_s
            FileUtils.mkdir_p(destination.dirname)
            File.write(destination, response.body)
          else
            Statique.ui.error "Error building page", path: path.to_s, status: response.status
          end
        end
      end

      def mock_request
        @mock_request ||= Rack::MockRequest.new(statique.app)
      end

      def copy_public_assets
        assets = statique.public.glob("**/*.*")
        Statique.ui.info "Copying public assets", assets:
        FileUtils.cp_r(assets, statique.destination)
      end
    end
  end
end
