require "roda"
require "slim"

module Statique
  class App < Roda
    opts[:root] = Statique.pwd

    if Statique.public?
      plugin :public, root: Statique.public.basename
    end

    plugin :render, views: Statique.content.basename, engine: "slim", allowed_paths: [Statique.content.basename, Statique.layouts.basename]

    route do |r|
      if Statique.public?
        r.public
      end

      r.root do
        view("index", engine: "slim", layout: "../layouts/layout")
      end
    end
  end
end
