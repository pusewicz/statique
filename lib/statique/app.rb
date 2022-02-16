# frozen_string_literal: true

require "roda"
require "slim"
require "digest/sha1"

class Statique
  class App < Roda
    extend Forwardable

    def_delegators :Statique, :url, :root_url

    opts[:root] = Statique.configuration.paths.pwd

    plugin :environments
    plugin :static_routing
    plugin :render, views: Statique.configuration.paths.content.basename, engine: "slim", allowed_paths: [Statique.configuration.paths.content.basename, Statique.configuration.paths.layouts.basename]
    plugin :partials, views: Statique.configuration.paths.layouts.basename

    if Statique.mode.server? && Statique.configuration.paths.public.exist?
      plugin :public, root: Statique.configuration.paths.public.basename
    end

    if Statique.configuration.paths.assets.exist?
      css_files = Statique.configuration.paths.assets.join("css").glob("*.{css,scss}")
      js_files = Statique.configuration.paths.assets.join("js").glob("*.js")
      plugin :assets, css: css_files.map { _1.basename.to_s }, js: js_files.map { _1.basename.to_s }, public: Statique.configuration.paths.destination, precompiled: Statique.configuration.paths.destination.join("assets/manifest.json"), relative_paths: true
      plugin :assets_preloading

      Statique.mode.build do
        compiled = compile_assets
        Statique.ui.info "Compiling assets", css: compiled["css"], js: compiled["js"]
      end
    end

    route do |r|
      if Statique.mode.server?
        r.public if Statique.configuration.paths.public.exist?
        r.assets if Statique.configuration.paths.assets.exist?
      end

      path, page = r.env["REQUEST_PATH"].split("/page/")

      document = Statique.discover.documents.find { _1.path == path }

      r.on(proc { document }) do
        locals = {
          documents: Statique.discover.documents,
          collections: Statique.discover.collections,
          document: document
        }

        if document.meta.paginates
          paginator = Paginator.new(Statique.discover.collections[document.meta.paginates].to_a, document.path, page)
          locals[document.meta.paginates.to_sym] = paginator.documents
          locals[:paginator] = paginator
        end

        options = {
          engine: document.engine_name,
          inline: document.content,
          locals:,
          layout_opts: {locals:},
          cache_key: Digest::SHA1.hexdigest(document.file.to_s + document.content),
          layout: "../layouts/#{document.layout_name}"
        }

        if document.layout_name
          view(options)
        else
          render(options)
        end
      end
    end
  end
end
