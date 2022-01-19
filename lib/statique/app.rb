# frozen_string_literal: true

require "roda"
require "slim"

module Statique
  class App < Roda
    opts[:root] = Statique.pwd

    if Statique.public?
      plugin :public, root: Statique.public.basename
    end

    plugin :static_routing
    plugin :render, views: Statique.content.basename, engine: "slim", allowed_paths: [Statique.content.basename, Statique.layouts.basename]

    if Statique.assets?
      css_files = Statique.assets.join("css").glob("*.{css,scss}")
      js_files = Statique.assets.join("js").glob("*.js")
      plugin :assets, css: css_files.map { _1.basename.to_s }, js: js_files.map { _1.basename.to_s }, public: Statique.destination
    end

      Statique.ui.info "Route", mount: route.mount_point, view: route.view_name, engine: route.engine_name
      static_get route.mount_point do |r|
        view(route.view_name, engine: route.engine_name, layout: "../layouts/layout")
    Statique.discover.routes.each do |route, document|
      end
    end

    route do |r|
      r.public if Statique.public?
      r.assets if Statique.assets?
    end
  end
end
