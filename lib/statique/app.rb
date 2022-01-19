# frozen_string_literal: true

require "roda"
require "slim"

module Statique
  class App < Roda
    opts[:root] = Statique.pwd

    if Statique.public?
      plugin :public, root: Statique.public.basename
    end

    plugin :environments
    plugin :static_routing
    plugin :render, views: Statique.content.basename, engine: "slim", allowed_paths: [Statique.content.basename, Statique.layouts.basename]

    if Statique.assets?
      css_files = Statique.assets.join("css").glob("*.{css,scss}")
      js_files = Statique.assets.join("js").glob("*.js")
      plugin :assets, css: css_files.map { _1.basename.to_s }, js: js_files.map { _1.basename.to_s }, public: Statique.destination
      plugin :assets_preloading
    end

    Statique.discover.routes.each do |route, document|
      static_get route do |r|
        locals = {
          document:
        }
        view(document.view_name, engine: document.engine_name, layout: "../layouts/#{document.layout_name}", locals:)
      end
    end

    route do |r|
      r.public if Statique.public?
      r.assets if Statique.assets?
    end
  end
end
