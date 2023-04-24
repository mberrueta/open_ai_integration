# ruby generate_test.rb

require "optparse"
require_relative "lib/open_ai_integration"

options = {
  api_key: ENV["OPEN_AI_API_KEY"],
}

OptionParser.new do |parser|
  parser.on("-p", "--path SRC_PATH", "File path for the file to generate test") do |value|
    options[:path] = value
  end
  parser.on("-tf", "--test-framework TEST_FRAMEWORK", ":rspec, :minitest, nil") do |value|
    options[:test_framework] = value
  end
  parser.on("-ak", "--api-key API_KEY", "Your open AI API_KEY") do |value|
    options[:api_key] = value
  end
end.parse!

if options[:path]
  puts "generating test for #{options[:path]} with #{OpenAiIntegration::VERSION} version"

  OpenAiIntegration::TestGeneration.new.generate_test(options)
else
  puts "File is required ! I can't generate test for nothing 😠!"
end
