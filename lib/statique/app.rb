require "roda"
require "slim"

module Statique
  class App < Roda
    opts[:root] = Statique.pwd

    if Statique.public?
      plugin :public, root: Statique.public.basename
    end

    plugin :render, views: Statique.content.basename, engine: "slim", allowed_paths: [Statique.content.basename, Statique.layouts.basename]

    if Statique.assets?
      css_files = Statique.assets.join("css").glob("*.{css,scss}")
      js_files = Statique.assets.join("js").glob("*.js")
      plugin :assets, css: css_files.map { _1.basename.to_s }, js: js_files.map { _1.basename.to_s }, public: Statique.destination
    end

    route do |r|
      r.public if Statique.public?
      r.assets if Statique.assets?

      r.root do
        view("index", engine: "slim", layout: "../layouts/layout")
      end
    end
  end
end
