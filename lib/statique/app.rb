# frozen_string_literal: true

require "roda"
require "slim"

module Statique
  class App < Roda
    opts[:root] = Statique.pwd

    plugin :environments
    plugin :static_routing
    plugin :render, views: Statique.content.basename, engine: "slim", allowed_paths: [Statique.content.basename, Statique.layouts.basename]

    if Statique.mode.server? && Statique.public?
      plugin :public, root: Statique.public.basename

      route do |r|
        r.public
      end
    end

    if Statique.assets?
      css_files = Statique.assets.join("css").glob("*.{css,scss}")
      js_files = Statique.assets.join("js").glob("*.js")
      plugin :assets, css: css_files.map { _1.basename.to_s }, js: js_files.map { _1.basename.to_s }, public: Statique.destination, precompiled: Statique.destination.join("assets/manifest.json")
      plugin :assets_preloading

      if Statique.mode.server?
        route do |r|
          r.assets
        end
      end

      Statique.mode.build do
        compiled = compile_assets
        Statique.ui.info "Compiling assets", css: compiled["css"], js: compiled["js"]
      end
    end

    Statique.discover.routes.each do |route, document|
      static_get route do |r|
        locals = {
          document:
        }
        view(document.view_name, engine: document.engine_name, layout: "../layouts/#{document.layout_name}", locals:)
      end
    end
  end
end
