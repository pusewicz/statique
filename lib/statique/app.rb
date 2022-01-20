# frozen_string_literal: true

require "roda"
require "slim"

class Statique
  class App < Roda
    statique = Statique.instance

    opts[:root] = statique.pwd

    plugin :environments
    plugin :static_routing
    plugin :render, views: statique.content.basename, engine: "slim", allowed_paths: [statique.content.basename, statique.layouts.basename]
    plugin :render_locals, render: {statique:, documents: statique.discover.documents.values}, merge: true

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
        statique.ui.info "Compiling assets", css: compiled["css"], js: compiled["js"]
      end
    end

    statique.discover.routes.each do |route, document|
      static_get route do |r|
        locals = {
          document:
        }

        if document.layout_name
          view(document.view_name, inline: document.content, engine: document.engine_name, layout: "../layouts/#{document.layout_name}", locals:, layout_opts: {locals:})
        else
          render(document.view_name, inline: document.content, engine: document.engine_name, locals:, layout_opts: {locals:})
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
