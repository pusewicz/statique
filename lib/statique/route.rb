# frozen_string_literal: true

module Statique
  class Route
    attr_reader :path

    def initialize(path)
      @path = path.freeze
    end

    def mount_point
      case basename
      when "index.slim" then "/"
      else
        "/#{basename.delete_suffix(extname).delete_prefix(Statique.content.to_s)}"
      end.freeze
    end

    def view_name
      basename.delete_suffix(extname).freeze
    end

    def engine_name
      extname.delete_prefix(".").freeze
    end

    private

    def basename
      @basename ||= path.basename.to_s.freeze
    end

    def extname
      @extname ||= path.extname.to_s.freeze
    end
  end
end
