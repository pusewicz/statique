# frozen_string_literal: true

require "roda"
require "slim"
require "digest/sha1"

class Statique
  class App < Roda
    extend Forwardable

    @statique = Statique.instance

    def_delegators :@statique, :url, :root_url, :statique

    opts[:root] = @statique.configuration.paths.pwd

    plugin :environments
    plugin :static_routing
    plugin :render, views: @statique.configuration.paths.content.basename, engine: "slim", allowed_paths: [@statique.configuration.paths.content.basename, @statique.configuration.paths.layouts.basename]
    plugin :partials, views: @statique.configuration.paths.layouts.basename

    if @statique.configuration.paths.assets.exist?
      css_files = @statique.configuration.paths.assets.join("css").glob("*.{css,scss}")
      js_files = @statique.configuration.paths.assets.join("js").glob("*.js")
      plugin :assets, css: css_files.map { _1.basename.to_s }, js: js_files.map { _1.basename.to_s }, public: @statique.configuration.paths.destination, precompiled: @statique.configuration.paths.destination.join("assets/manifest.json"), relative_paths: true
      plugin :assets_preloading

      @statique.mode.build do
        compiled = compile_assets
        @statique.ui.info "Compiling assets", css: compiled["css"], js: compiled["js"]
      end
    end

    route do |r|
      @statique = Statique.instance

      path, page = r.env["PATH_INFO"].split("/page/")

      document = @statique.discover.documents.find { _1.path == path }

      r.on(proc { document }) do
        locals = {
          collections: @statique.discover.collections,
          document: document,
          documents: @statique.discover.documents,
          statique: @statique
        }

        if document.meta.paginates
          paginator = Paginator.new(@statique.discover.collections[document.meta.paginates].to_a, document.path, page, @statique)
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
