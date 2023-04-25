require "pry"
require "spec_helper"

# rspec spec/test_generation/elixir_spec.rb
RSpec.describe OpenAiIntegration::TestGeneration, "#generate_test for elixir" do
  before do
    @options = {
      api_key: "sk-1234567890",
      path: File.path("./spec/samples/show_live.ex"),
    }

    expect_any_instance_of(Net::HTTP).to receive(:post).and_return(
      double().tap do |d|
        allow(d).to receive(:body).and_return(
                      {
                        "choices" => [
                          {
                            "text" => "\n\nHere is an example test for the code above:\n\ndefmodule MyAppWeb.ThermostatLiveTest do\n  use ExUnit.Case\n  use MyAppWeb.ConnCase\n\n  test \"mount assigns the temperature from the Thermostat module\" do\n    user_id = 1\n    temperature = 20\n\n    Thermostat = %{get_user_reading: fn(_user_id) -> temperature end}\n\n    {:ok, socket} = connect(MyAppWeb.ThermostatLive, %{\"current_user_id\" => user_id}, Thermostat)\n\n    assert socket.assigns.temperature == temperature\n  end\nend",
                          },
                        ],
                      }.to_json
                    )
      end
    )

    allow(FileUtils).to receive(:mkdir_p).and_return(true)
    expect(File).to receive(:write).and_return(true)
  end

  subject { OpenAiIntegration::TestGeneration.new }

  let(:expected_result) do
    "defmodule MyAppWeb.ThermostatLiveTest do
  use ExUnit.Case
  use MyAppWeb.ConnCase

  test \"mount assigns the temperature from the Thermostat module\" do
    user_id = 1
    temperature = 20

    Thermostat = %{get_user_reading: fn(_user_id) -> temperature end}

    {:ok, socket} = connect(MyAppWeb.ThermostatLive, %{\"current_user_id\" => user_id}, Thermostat)

    assert socket.assigns.temperature == temperature
  end
end"
  end
  it "should generate test for elixir" do
    result = subject.generate_test(@options)

    expect(result.language).to eq(:elixir)
    expect(result.dest_file).to eq("show_live_test.exs")
    expect(result.dest_folder).to eq("./test/spec/samples")
    expect(result.result).to eq(expected_result)
  end
end
