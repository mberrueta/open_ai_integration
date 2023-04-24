require "pry"
require "spec_helper"

# rspec spec/test_generation/ruby_spec.rb
RSpec.describe OpenAiIntegration::TestGeneration, "#generate_test for ruby" do
  before do
    @options = {
      api_key: "sk-1234567890",
      path: File.absolute_path("./spec/samples/hello_world.rb"),
      test_framework: :rspec,
    }

    expect_any_instance_of(Net::HTTP).to receive(:post).and_return(
      double().tap do |d|
        allow(d).to receive(:body).and_return(
                      {
                        "choices" => [
                          {
                            "text" => "Here is an example of a test using RSpec: \n\nrequire 'rspec'\n\ndescribe Samples::HelloWorld do\n  subject { described_class.new }\n\n  describe '#say_hello' do\n    it 'returns a greeting with the name' do\n      expect(subject.say_hello).to eq('Hello World! John Doe')\n    end\n  end\nend",
                          },
                        ],
                      }.to_json
                    )
      end
    )

    expect(FileUtils).to receive(:mkdir_p).and_return(true)
    expect(File).to receive(:write).and_return(true)
  end

  subject { OpenAiIntegration::TestGeneration.new }

  let(:expected_result) do
    "require 'rspec'

describe Samples::HelloWorld do
  subject { described_class.new }

  describe '#say_hello' do
    it 'returns a greeting with the name' do
      expect(subject.say_hello).to eq('Hello World! John Doe')
    end
  end
end"
  end
  it "should generate test for ruby" do
    result = subject.generate_test(@options)

    expect(result.language).to eq(:ruby)
    expect(result.dest_file).to eq("/spec/samples/hello_world_spec.rb")
    expect(result.dest_folder).to eq("/spec/samples/")
    expect(result.test_framework).to eq(:rspec)
    expect(result.result).to eq(expected_result)
  end
end
