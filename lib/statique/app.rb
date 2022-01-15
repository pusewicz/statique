require "roda"

module Statique
  class App < Roda
    opts[:root] = Statique.pwd

    if Statique.public?
      plugin :public, root: Statique.public.basename
    end

    route do |r|
      if Statique.public?
        r.public
      end

      r.root do
        "Hello!"
      end
    end
  end
end
