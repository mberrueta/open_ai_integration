require "fileutils"
require "pry"
require_relative "ruby_test_generation"
require_relative "elixir_test_generation"
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

      folder = "#{File.expand_path(".")}/#{metadata.dest_folder}"
      file = "#{folder}/#{metadata.dest_file}"
      logger.info("folder: #{folder}, file: #{metadata.dest_file}")

      FileUtils.mkdir_p(folder) unless Dir.exist?(folder)
      File.write(file, metadata.result, mode: "a")

      pp "File created at: #{file}"
      metadata
    end

    private

    def define_language(path, content, test_framework)
      case File.extname(path)
      when ".rb"
        RubyTestGeneration.new.generate(path, content, test_framework)
      when ".ex"
        ElixirTestGeneration.new.generate(path, content)
      else
        "unknown"
      end
    end

    def logger
      @logger ||= Logger.new(STDOUT)
    end
  end
end
