require "pry"
require_relative "ruby_test_generation"

module OpenAiIntegration
  class TestGeneration

    # magic happens here
    def generate_test(opts)
      path = opts[:path]
      test_framework = opts[:test_framework]

      file = File.open(path, "r")
      content = file.read
      file.close

      metadata = define_language(path, content, test_framework)

      metadata
    end

    private

    def define_language(path, content, test_framework)
      case File.extname(path)
      when ".rb"
        RubyTestGeneration.new.generate(path, content, test_framework)
      when ".ex"
        data[:language] = :elixir
      else
        "unknown"
      end
    end
  end
end
