require "http"

module Statique
  class CLI
    class Build
      def initialize(options)
      end

      def run
        HTTP.persistent "http://localhost:3000" do |http|
          mapping.each do |from, to|
            dst = Statique.destination.join(to)
            Statique.ui.info "Building #{from} and writing to #{dst}"
            File.write(dst, http.get(from).to_s)
          end
        end
      end

      private

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
