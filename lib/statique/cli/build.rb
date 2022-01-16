require "http"

module Statique
  class CLI
    class Build
      def initialize(options)
      end

      def run
        compile_assets
        copy_public_assets
        start_server
        HTTP.persistent "http://127.0.0.1:3000" do |http|
          mapping.each do |from, to|
            dst = Statique.destination.join(to)
            Statique.ui.info "Building page", path: from.to_s
            File.write(dst, http.get(from).to_s)
          end
        end
        Statique.ui.success "Done!"
      ensure
        stop_server
      end

      private

      def compile_assets
        Statique.ui.info "Compiling assets"
        Statique.app.compile_assets
      end

      def copy_public_assets
        Statique.ui.info "Copying public assets"
        FileUtils.cp_r(Statique.public.glob("**/*.*"), Statique.destination)
      end

      def start_server
        @server = Server.new
        @server.run
      end

      def stop_server
        @server&.stop
      end

      def mapping
        {
          "/" => "index.html"
        }
      end
    end
  end
end
