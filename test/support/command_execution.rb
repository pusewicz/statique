# frozen_string_literal: true

class Statique
  module Support
    CommandExecution = Struct.new(:command, :working_directory, :exitstatus, :stdout, :stderr) do
      def to_s
        "$ #{command}"
      end
      alias_method :inspect, :to_s

      def stdboth
        @stdboth ||= [stderr, stdout].join("\n").strip
      end

      def to_s_verbose
        [
          to_s,
          stdout,
          stderr,
          exitstatus ? "# $? => #{exitstatus}" : ""
        ].reject(&:empty?).join("\n")
      end

      def success?
        return true unless exitstatus
        exitstatus == 0
      end

      def failure?
        return true unless exitstatus
        exitstatus > 0
      end
    end
  end
end
