# frozen_string_literal: true

require "roda"
require "slim"
require "digest/sha1"
require "pagy"
require "pagy/extras/array"
require "rack/rewrite"

class Statique
  class App < Roda
    PAGE_REGEX = /(.*)\/page\/(\d+)/
    use Rack::Rewrite do
      rewrite PAGE_REGEX, "$1?page=$2"
    end

    include Pagy::Backend
    include Pagy::Frontend

    Pagy::DEFAULT[:items] = 3

    def pagination_nav
      pagy_nav(@pagy).gsub(/\?page=(\d+)/, '/page/\1')
    end

    statique = Statique.instance

    opts[:root] = statique.pwd

    plugin :environments
    plugin :static_routing
    plugin :render, views: statique.content.basename, engine: "slim", allowed_paths: [statique.content.basename, statique.layouts.basename]

    if statique.mode.server? && statique.public?
      plugin :public, root: statique.public.basename
    end

    if statique.assets?
      css_files = statique.assets.join("css").glob("*.{css,scss}")
      js_files = statique.assets.join("js").glob("*.js")
      plugin :assets, css: css_files.map { _1.basename.to_s }, js: js_files.map { _1.basename.to_s }, public: statique.destination, precompiled: statique.destination.join("assets/manifest.json")
      plugin :assets_preloading

      statique.mode.build do
        compiled = compile_assets
        Statique.ui.info "Compiling assets", css: compiled["css"], js: compiled["js"]
      end
    end

    statique.discover.routes.each do |path, document|
      Statique.ui.debug "Defining route", {path:, file: document.file}
      static_get path do |r|
        @document = statique.discover.documents[document.file.to_s]

        locals = {
          statique:,
          documents: statique.discover.documents.values,
          collections: statique.discover.collections,
          document: @document
        }

        if @document.meta.paginates
          @pagy, items = pagy_array(statique.discover.collections[@document.meta.paginates].to_a, {page: r.params.fetch("page", 1)})
          locals[@document.meta.paginates.to_sym] = items
          locals[:paginator] = @pagy
        end

        options = {
          engine: @document.engine_name,
          inline: @document.content,
          locals:,
          layout_opts: {locals:},
          cache_key: Digest::SHA1.hexdigest(@document.file.to_s + @document.content),
          layout: "../layouts/#{@document.layout_name}"
        }

        if document.layout_name
          view(options)
        else
          render(options)
        end
      end
    end

    if statique.mode.server?
      # Mout routes at once, as calling #route clears the previous block
      route do |r|
        r.public if statique.public?
        r.assets if statique.assets
      end
    end
  end
end
