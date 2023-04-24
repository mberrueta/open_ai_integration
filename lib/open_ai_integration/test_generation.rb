require "fileutils"
require "pry"
require_relative "ruby_test_generation"
require "logger"

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

      logger.info(metadata)

      FileUtils.mkdir_p(metadata.dest_folder) unless Dir.exist?(metadata.dest_folder)
      File.write(metadata.dest_file, metadata.result, mode: "a")
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

    def logger
      @logger ||= Logger.new(STDOUT)
    end
  end
end
