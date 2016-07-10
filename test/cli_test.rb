require_relative './test_helper'

class Tumugi::Plugin::Command::CLITest < Tumugi::Test::TumugiTestCase
  examples = {
    'run_command' => ['run_command.rb', 'task1'],
    'run_external_script' => ['run_external_script.rb', 'task1'],
    'save_result_to_file' => ['save_result_to_file.rb', 'task1'],
  }

  setup do
    system('rm -rf tmp/*')
  end

  data do
    data_set = {}
    examples.each do |k, v|
      [1, 2, 8].each do |n|
        data_set["#{k}_workers_#{n}"] = (v.dup << n)
      end
    end
    data_set
  end
  test 'success' do |(file, task, worker)|
    assert_run_success("examples/#{file}", task, workers: worker, config: "examples/tumugi_config.rb", verbose: true, quiet: false)
  end
end
