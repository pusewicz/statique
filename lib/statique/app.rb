require "roda"

module Statique
  class App < Roda
    route do |r|
      r.root do
        "Hello!"
      end
    end
  end
end
