require 'open3'
require 'shellwords'

require 'tumugi/plugin'
require 'tumugi/plugin/target/local_file.rb'
require 'tumugi/task'

module Tumugi
  module Plugin
    class CommandBase < Tumugi::Task
      param :output_file, type: :string
      param :env, type: :hash, default: {}
      param :quiet, type: :bool, default: false

      def output
        unless output_file.nil?
          @output ||= Tumugi::Plugin::LocalFileTarget.new(output_file)
        else
          nil
        end
      end

      def run_command(cmd)
        log "Execute command: #{cmd}"
        begin
          out, err, status = Open3.capture3(env, *Shellwords.split(cmd))
        rescue => e
          raise Tumugi::TumugiError, e.message
        end

        logger.info  "stdout:\n" + out unless out.empty? or quiet
        logger.error "stderr:\n" + err unless err.empty?

        if status.exitstatus == 0
          if output_file && _output
            log "Save STDOUT into #{output.path}"
            output.open('w') do |f|
              f.print(out)
            end
          end
        else
          raise Tumugi::TumugiError, "Command failed: exit status is #{status.exitstatus}"
        end
      end
    end

    class CommandTask < CommandBase
      Tumugi::Plugin.register_task('command', self)

      param :command, type: :string, required: true

      def run
        run_command(command)
      end
    end
  end
end
