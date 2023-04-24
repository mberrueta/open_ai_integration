# ruby generate_test.rb

require "optparse"
require_relative "lib/open_ai_integration"

options = {}

OptionParser.new do |parser|
  parser.on("-p", "--path SRC_PATH", "File path for the file to generate test") do |value|
    options[:path] = value
  end
end.parse!

if options[:path]
  puts "generating test for #{options[:path]} with #{OpenAiIntegration::VERSION} version"

  OpenAiIntegration::TestGeneration.new.generate_test(options)
else
  puts "File is required ! I can't generate test for nothing 😠!"
end
