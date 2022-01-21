# frozen_string_literal: true

require "roda"
require "slim"
require "digest/sha1"
require "pagy"
require "pagy/extras/array"
require "rack/rewrite"
require "forwardable"

class Statique
  class App < Roda
    extend Forwardable
    include Pagy::Backend
    include Pagy::Frontend

    PAGE_REGEX = /(.*)\/page\/(\d+)/
    use Rack::Rewrite do
      rewrite PAGE_REGEX, "$1?page=$2"
    end

    Pagy::DEFAULT[:items] = 3

    def_delegators :Statique, :url, :root_url

    def pagination_nav
      pagy_nav(@pagy).gsub(/\?page=(\d+)/, '/page/\1')
    end

    opts[:root] = Statique.pwd

    plugin :environments
    plugin :static_routing
    plugin :render, views: Statique.content.basename, engine: "slim", allowed_paths: [Statique.content.basename, Statique.layouts.basename]
    plugin :partials, views: Statique.layouts.basename

    if Statique.mode.server? && Statique.public?
      plugin :public, root: Statique.public.basename
    end

    if Statique.assets?
      css_files = Statique.assets.join("css").glob("*.{css,scss}")
      js_files = Statique.assets.join("js").glob("*.js")
      plugin :assets, css: css_files.map { _1.basename.to_s }, js: js_files.map { _1.basename.to_s }, public: Statique.destination, precompiled: Statique.destination.join("assets/manifest.json")
      plugin :assets_preloading

      Statique.mode.build do
        compiled = compile_assets
        Statique.ui.info "Compiling assets", css: compiled["css"], js: compiled["js"]
      end
    end

    Statique.discover.routes.each do |path, document|
      Statique.ui.debug "Defining route", {path:, file: document.file}
      static_get path do |r|
        @document = Statique.discover.documents[document.file.to_s]

        locals = {
          documents: Statique.discover.documents.values,
          collections: Statique.discover.collections,
          document: @document
        }

        if @document.meta.paginates
          @pagy, items = pagy_array(Statique.discover.collections[@document.meta.paginates].to_a, {page: r.params.fetch("page", 1)})
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

    if Statique.mode.server?
      # Mout routes at once, as calling #route clears the previous block
      route do |r|
        r.public if Statique.public?
        r.assets if Statique.assets
      end
    end
  end
end
