module OpenAiIntegration
  class ElixirTestGeneration
    def generate(path, content)
      data.dest_file = "#{File.basename(path, ".*")}_test.exs"
      data.dest_folder = destination_path(path)
      prompt = "Hello ! please as an expert create a test for this code using elixir " \
      ': \n ```\n' + content + '\n```\n'
      result = Http::OpenAiClient.new.completions(prompt)
      data.result = format(result)
      data
    end

    private

    def format(result)
      regex = /(defmodule .*end)$/m
      result.match(regex)[0]
    end

    def data
      @data ||= TestData.new.tap do |data|
        data.language = :elixir
      end
    end

    def destination_path(path)
      regex = /^\.*\/*(.*)\/.*\.ex$/
      "./test/#{File.path(path).match(regex)[1]}"
    end
  end
end
