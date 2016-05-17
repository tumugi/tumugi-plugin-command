require_relative './test_helper'

class Tumugi::Plugin::Command::CLITest < Test::Unit::TestCase
  examples = {
    'run_command' => ['run_command.rb', 'task1'],
    'run_external_script' => ['run_external_script.rb', 'task1'],
    'save_result_to_file' => ['save_result_to_file.rb', 'task1'],
  }

  def exec(file, task, options)
    return true if ENV['TRAVIS']
    system("bundle exec tumugi run -f ./examples/#{file} #{options} #{task}")
  end

  data(examples)
  test 'success' do |(file, task)|
    assert_true(exec(file, task, "-w 4 --quiet"))
  end
end
