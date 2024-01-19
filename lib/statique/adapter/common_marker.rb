# frozen_string_literal: true

class Statique
  module Adapter
    class CommonMarker
      def self.render_doc(data, parse_options, _extensions)
        new(data, parse_options)
      end

      def initialize(data, parse_options)
        @data = data
        @parse_options = parse_options.is_a?(Symbol) ? {} : parse_options
      end

      def to_html(render_options, _extensions)
        @html ||= ::Commonmarker.to_html(@data, options: {
          parse: @parse_options,
          render: render_options.is_a?(Symbol) ? {} : render_options
        })
      end
    end
  end
end
