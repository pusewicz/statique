# frozen_string_literal: true

require "roda"
require "slim"
require "digest/sha1"
require "rack/rewrite"
require "rack/rewrite/rule"
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

    def_delegators :Statique, :url, :root_url

    def pagination_nav
      pagy_nav(@pagy).gsub(/\?page=(\d+)/, '/page/\1')
    end

    opts[:root] = Statique.paths.pwd

    plugin :environments
    plugin :static_routing
    plugin :render, views: Statique.paths.content.basename, engine: "slim", allowed_paths: [Statique.paths.content.basename, Statique.paths.layouts.basename]
    plugin :partials, views: Statique.paths.layouts.basename

    if Statique.mode.server? && Statique.paths.public.exist?
      plugin :public, root: Statique.paths.public.basename
    end

    if Statique.paths.assets.exist?
      css_files = Statique.paths.assets.join("css").glob("*.{css,scss}")
      js_files = Statique.paths.assets.join("js").glob("*.js")
      plugin :assets, css: css_files.map { _1.basename.to_s }, js: js_files.map { _1.basename.to_s }, public: Statique.paths.destination, precompiled: Statique.paths.destination.join("assets/manifest.json")
      plugin :assets_preloading

      Statique.mode.build do
        compiled = compile_assets
        Statique.ui.info "Compiling assets", css: compiled["css"], js: compiled["js"]
      end
    end

    Statique.discover.documents.each do |document|
      Statique.ui.debug "Defining route", {path: document.path, file: document.file}
      static_get document.path do |r|
        @document = Statique.discover.documents.find { _1.file == document.file }

        locals = {
          documents: Statique.discover.documents,
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
      route do |r|
        r.public if Statique.paths.public.exist?
        r.assets if Statique.paths.assets.exist?
      end
    end
  end
end
