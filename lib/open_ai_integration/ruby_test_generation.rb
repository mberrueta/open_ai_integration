require "pry"
require_relative "test_data"

module OpenAiIntegration
  class RubyTestGeneration
    def generate(path, content, test_framework)
      data.test_framework = test_framework || :rspec

      case data.test_framework
      when :rspec
        data.dest_file = destination_path(path)
        data.dest_folder = data.dest_file.gsub("#{File.basename(path, ".*")}_spec.rb", "")
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
      file_name = File.basename(path, ".*")
      folder = File.path(path).gsub(File.expand_path("."), "").gsub(file_name, "").gsub(".rb", "")
      "#{folder}#{file_name}_spec.rb"
    end
  end
end
