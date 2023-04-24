require "pry"
require "spec_helper"

# rspec spec/test_generation/ruby_spec.rb
RSpec.describe OpenAiIntegration::TestGeneration, "#generate_test for ruby" do
  before do
    @options = {
      path: File.absolute_path("./spec/samples/hello_world.rb"),
      test_framework: :rspec,
    }
  end

  subject { OpenAiIntegration::TestGeneration.new }

  it "should generate test for ruby" do
    result = subject.generate_test(@options)
    expect(result.language).to eq(:ruby)
    expect(result.dest).to eq("./spec/hello_world_spec.rb")
    expect(result.test_framework).to eq(:rspec)
  end
end
