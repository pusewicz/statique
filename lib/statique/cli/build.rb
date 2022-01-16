require "http"

module Statique
  class CLI
    class Build
      def initialize(options)
      end

      def run
        compile_assets
        start_server
        HTTP.persistent "http://127.0.0.1:3000" do |http|
          mapping.each do |from, to|
            dst = Statique.destination.join(to)
            Statique.ui.info "Building #{from} and writing to #{dst}"
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

      def start_server
        @server = Server.new
        @server.run
      end

      def stop_server
        @server.stop
      end

      def mapping
        {
          "/" => "index.html"
        }.merge(public_mapping)
      end

      def public_mapping
        Statique.public.glob("**/*").map do |path|
          path = path.to_s.delete_prefix(Statique.public.to_s)
          [path, path.delete_prefix("/")]
        end.to_h
      end
    end
  end
end
