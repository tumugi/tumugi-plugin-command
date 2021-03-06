require_relative '../../test_helper'
require 'fileutils'
require 'tumugi/plugin/task/command'

class Tumugi::Plugin::CommandTaskTest < Test::Unit::TestCase
  class << self
    def startup
      FileUtils.mkdir_p('./test/tmp')
    end
  end

  setup do
    @env = { "KEY1" => "value1" }
    @klass = Class.new(Tumugi::Plugin::CommandTask)
    @klass.set(:command, 'echo test')
    @klass.set(:output_file, './test/tmp/result_test.txt')
    @klass.set(:env, @env)
  end

  sub_test_case "parameters" do
    test "should set correctly" do
      task = @klass.new
      assert_equal('echo test', task.command)
      assert_equal('./test/tmp/result_test.txt', task.output_file)
      assert_equal({ "KEY1" => "value1" }, task.env)
    end

    data({
      "command" => [:command],
    })
    test "raise error when required parameter is not set" do |params|
      params.each do |param|
        @klass.set(param, nil)
      end
      assert_raise(Tumugi::ParameterError) do
        @klass.new
      end
    end
  end

  sub_test_case "#output" do
    test "when output_file is set" do
      task = @klass.new
      output = task.output
      assert_true(output.is_a? Tumugi::Plugin::LocalFileTarget)
      assert_equal('./test/tmp/result_test.txt', output.path)
    end

    test "when output_file is not set" do
      @klass.set(:output_file, nil)
      task = @klass.new
      assert_nil(task.output)
    end
  end

  sub_test_case "#run" do
    test "when output_file is set" do
      task = @klass.new
      output = task.output
      task.run
      assert_true(File.exist? output.path)
      assert_equal("test\n", File.read(output.path))
    end

    test "when output_file is not set" do
      @klass.set(:output_file, nil)
      task = @klass.new
      task.run
    end

    test "command can read task.env" do
      @klass.set(:command, 'test/data/echo.sh')
      task = @klass.new
      output = task.output
      task.run
      assert_equal("#{@env['KEY1']}\n", File.read(output.path))
    end

    test "raise error when command return code is non zero value" do
      @klass.set(:command, './test/data/error.sh')
      task = @klass.new
      assert_raise(Tumugi::TumugiError) do
        task.run
      end
    end

    test "raise error when command run failed" do
      @klass.set(:command, 'invalid_command')
      task = @klass.new
      assert_raise(Tumugi::TumugiError) do
        task.run
      end
    end
  end
end
