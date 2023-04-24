require "pry"
require_relative "test_data"

module OpenAiIntegration
  class RubyTestGeneration
    def generate(path, content, test_framework)
      data.test_framework = test_framework || :rspec

      case data.test_framework
      when :rspec
        data.dest_file = "#{File.basename(path, ".*")}_spec.rb"
        data.dest_folder = destination_path(path)
        prompt = "Hello ! please as an expert create a test for this code using ruby " \
        'rspec: \n ```\n' + content + '\n```\n'
        result = Http::OpenAiClient.new.completions(prompt)
        data.result = format(result)
      when :minitest
        data.dest = "./test/#{File.basename(path, ".*")}_test.rb"
      else
        data.dest = "./test/#{File.basename(path, ".*")}.rb"
      end

      data
    end

    private

    def format(result)
      regex = /(require .*end)$/m
      result.match(regex)[0]
    end

    def data
      @data ||= TestData.new.tap do |data|
        data.language = :ruby
      end
    end

    def destination_path(path)
      regex = /^\.\/(.*)\/.*\.rb$/
      "spec/#{File.path(path).match(regex)[1]}"
    end
  end
end
