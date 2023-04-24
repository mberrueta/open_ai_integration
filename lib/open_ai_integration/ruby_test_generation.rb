require "pry"
require_relative "test_data"

module OpenAiIntegration
  class RubyTestGeneration
    def generate(path, content, test_framework = :rspec)
      data.test_framework = test_framework

      case test_framework
      when :rspec
        data.dest = "./spec/#{File.basename(path, ".*")}_spec.rb"
      when :minitest
        data.dest = "./test/#{File.basename(path, ".*")}_test.rb"
      else
        data.dest = "./test/#{File.basename(path, ".*")}.rb"
      end

      data
    end

    private

    def data
      @data ||= TestData.new.tap do |data|
        data.language = :ruby
      end
    end
  end
end
