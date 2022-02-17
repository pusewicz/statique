# frozen_string_literal: true

require "fileutils"

class Statique
  class CLI
    class Init
      def initialize(name)
        @dest_dir = Pathname.pwd.join(name || ".")
      end

      def run
        create_directory(@dest_dir)

        write_file(@dest_dir.join("public/robots.txt"), "User-agent: *\nAllow: /")
        write_file(@dest_dir.join("assets/css/app.css"), %(@import url("https://cdn.jsdelivr.net/npm/water.css@2/out/water.css");))
        write_file(@dest_dir.join("assets/js/app.js"), %(console.log("Hello from Statique!")))

        copy_template("index.md", @dest_dir.join("content"))
        copy_template("layout.slim", @dest_dir.join("layouts"))
      end

      private

      def create_directory(path)
        unless path.exist?
          Statique.ui.info "Creating directory", directory: path
          FileUtils.mkdir_p(path)
        end
      end

      def write_file(path, content)
        unless path.exist?
          create_directory(path.dirname)
          Statique.ui.info "Writing file", file: path
          File.write(path, content)
        end
      end

      def copy_template(name, dir)
        path = dir.join(name)
        unless path.exist?
          create_directory(dir)
          Statique.ui.info "Copying file", file: path
          FileUtils.cp(File.expand_path("../../../templates/#{name}", __FILE__), path)
        end
      end
    end
  end
end
