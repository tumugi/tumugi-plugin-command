task :task1, type: :command do
  requires :task2
  command { "cat #{input.path}" }
end

task :task2, type: :command do
  command "./examples/external_script.sh"
  output target(:local_file, "tmp/external_script_result.txt")
end
