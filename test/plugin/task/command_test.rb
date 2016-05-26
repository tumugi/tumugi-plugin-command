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
    @klass = Class.new(Tumugi::Plugin::CommandTask)
    @klass.param_set(:command, 'echo test')
    @klass.param_set(:output_file, './test/tmp/result_test.txt')
  end

  sub_test_case "parameters" do
    test "should set correctly" do
      task = @klass.new
      assert_equal('echo test', task.command)
      assert_equal('./test/tmp/result_test.txt', task.output_file)
    end

    data({
      "command" => [:command],
    })
    test "raise error when required parameter is not set" do |params|
      params.each do |param|
        @klass.param_set(param, nil)
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
      @klass.param_set(:output_file, nil)
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
      @klass.param_set(:output_file, nil)
      task = @klass.new
      task.run
    end

    test "raise error when command return code is non zero value" do
      @klass.param_set(:command, './test/data/error.sh')
      task = @klass.new
      assert_raise(Tumugi::TumugiError) do
        task.run
      end
    end

    test "raise error when command run failed" do
      @klass.param_set(:command, 'invalid_command')
      task = @klass.new
      assert_raise(Tumugi::TumugiError) do
        task.run
      end
    end
  end
end
