require "roda"
require "slim"

module Statique
  class App < Roda
    opts[:root] = Statique.pwd

    if Statique.public?
      plugin :public, root: Statique.public.basename
    end

    plugin :render, views: Statique.content.basename, engine: "slim", allowed_paths: [Statique.content.basename, Statique.layouts.basename]
    plugin :assets, css: "site.css", js: "site.js"

    route do |r|
      r.public if Statique.public?
      r.assets if Statique.assets?

      r.root do
        view("index", engine: "slim", layout: "../layouts/layout")
      end
    end
  end
end
