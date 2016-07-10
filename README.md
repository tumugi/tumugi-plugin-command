[![Build Status](https://travis-ci.org/tumugi/tumugi-plugin-command.svg?branch=master)](https://travis-ci.org/tumugi/tumugi-plugin-command) [![Code Climate](https://codeclimate.com/github/tumugi/tumugi-plugin-command/badges/gpa.svg)](https://codeclimate.com/github/tumugi/tumugi-plugin-command) [![Coverage Status](https://coveralls.io/repos/github/tumugi/tumugi-plugin-command/badge.svg?branch=master)](https://coveralls.io/github/tumugi/tumugi-plugin-command)  [![Gem Version](https://badge.fury.io/rb/tumugi-plugin-command.svg)](https://badge.fury.io/rb/tumugi-plugin-command)

# Command plugin for [tumugi](https://github.com/tumugi/tumugi)

tumugi-plugin-command is a tumugi plugin to execute a command.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tumugi-plugin-command'
```

And then execute `bundle install`.

## Task

### Tumugi::Plugin::CommandTask

`Tumugi::Plugin::CommandTask` is task to execute a specified command.

#### Parameters

- **command** command which you want to execute (string, required)
- **output_file** output file path. If you specified this parameter, all outputs to STDOUT are saved in this file. (string)

#### Examples

- Run command

```rb
task :task1, type: :command do
  command "ls -la"
end
```

- Run command and save all outputs to STDOUT into file

```rb
task :task1, type: :command do
  command "echo 'success'"
  output_file "result.txt"
end
```

- Run external shell script

```sh:external_script.sh
#!/bin/sh
echo 'success' > tmp/external_script_result.txt
```

```rb
task :task1, type: :command do
  requires :task2
  command { "cat #{input.path}" }
end

task :task2, type: :command do
  command "./examples/external_script.sh"
  output target(:local_file, "tmp/external_script_result.txt")
end
```

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `bundle exec rake test` to run the tests.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tumugi/tumugi-plugin-command.

## License

The gem is available as open source under the terms of the [Apache License
Version 2.0](http://www.apache.org/licenses/).
