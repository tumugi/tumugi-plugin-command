require_relative './test_helper'
require 'tumugi/cli'

class Tumugi::Plugin::Command::CLITest < Test::Unit::TestCase
  examples = {
    'run_command' => ['run_command.rb', 'task1'],
    'run_external_script' => ['run_external_script.rb', 'task1'],
    'save_result_to_file' => ['save_result_to_file.rb', 'task1'],
  }

  def invoke(command, file, task, options)
    return true if ENV.key? 'TRAVIS'
    Tumugi::CLI.new.invoke(command, [task], options.merge(file: "./examples/#{file}", quiet: true))
  end

  data(examples)
  test 'success' do |(file, task)|
    assert_true(invoke(:run_, file, task, worker: 4))
  end
end
