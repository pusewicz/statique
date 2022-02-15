# frozen_string_literal: true

class Statique
  class Configuration
    attr_accessor :root_url
    attr_accessor :paths

    def initialize
      @root_url = "/"
      @paths = OpenStruct.new(
        pwd: Pathname.pwd,
        public: Pathname.pwd.join("public"),
        content: Pathname.pwd.join("content"),
        layouts: Pathname.pwd.join("layouts"),
        assets: Pathname.pwd.join("assets"),
        destination: Pathname.pwd.join("dist")
      )
    end
  end
end
