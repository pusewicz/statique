require "rack/mock"

module Statique
  class CLI
    class Build
      def initialize(options)
      end

      def run
        compile_assets
        copy_public_assets
        build_pages

        Statique.ui.success "Done!"
      end

      private

      def build_pages
        mapping.each do |from, to|
          response = mock_request.get(from)
          dst = Statique.destination.join(to)
          Statique.ui.info "Building page", path: from.to_s
          File.write(dst, response.body)
        end
      end

      def mock_request
        @mock_request ||= Rack::MockRequest.new(Statique.app)
      end

      def compile_assets
        Statique.ui.info "Compiling assets"
        Statique.app.compile_assets
      end

      def copy_public_assets
        assets = Statique.public.glob("**/*.*")
        Statique.ui.info "Copying public assets", assets:
        FileUtils.cp_r(assets, Statique.destination)
      end

      def mapping
        {
          "/" => "index.html"
        }
      end
    end
  end
end
