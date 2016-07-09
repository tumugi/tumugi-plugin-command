task :task1, type: :command do
  command "echo 'success'"
  output_file "tmp/result.txt"
end
