# frozen_string_literal: true

require_relative "command_execution"

class Statique
  module Support
    module Helpers
      def statique(cmd, raise_error: true, dir: @dir)
        exe = File.expand_path("../../exe/statique", __dir__)
        sys_exec "#{exe} #{cmd}", raise_error:, dir:
      end

      def command_executions
        @command_executions ||= []
      end

      def last_command
        command_executions.last || raise("There is no last command")
      end

      def out
        last_command.stdout
      end

      def err
        last_command.stderr
      end

      def sys_exec(cmd, dir:, raise_error: true)
        require "open3"
        require "shellwords"

        env = ENV.to_h
        command_execution = CommandExecution.new(cmd.to_s, dir)

        Open3.popen3(env, *cmd.shellsplit, chdir: dir) do |stdin, stdout, stderr, wait_thr|
          stdin.close
          stdout_read_thread = Thread.new { stdout.read }
          stderr_read_thread = Thread.new { stderr.read }
          command_execution.stdout = stdout_read_thread.value.strip
          command_execution.stderr = stderr_read_thread.value.strip

          status = wait_thr.value
          command_execution.exitstatus = status.exitstatus

          unless command_execution.success?
            raise <<~ERROR if raise_error
              Invoking `#{cmd}` failed with output:
              ----------------------------------------------------------------------
              #{command_execution.stdboth}
              ----------------------------------------------------------------------
            ERROR
          end
          command_executions << command_execution

          command_execution.stdout
        end
      end
    end
  end
end
