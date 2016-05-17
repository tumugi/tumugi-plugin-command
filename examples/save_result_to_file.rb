task :task1, type: :command do
  param_set :command, "echo 'success'"
  param_set :output_file, "tmp/result.txt"
end
