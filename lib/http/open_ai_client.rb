# require "http"
require "json"
require "net/http"

module Http
  class OpenAiClient
    def available_models()
      uri = URI(base_url + "/models")
      res = Net::HTTP.get_response(uri, headers())
      json = JSON.parse(res.body)

      json["data"].map { |model| model["root"] }
    end

    def completions(prompt)
      body = {
        model: "text-davinci-003",
        prompt: prompt,
        max_tokens: ENV["OPEN_AI_MAX_TOKENS"].to_i,
        temperature: ENV["OPEN_AI_TEMPERATURE"].to_f,
      }

      uri = URI(base_url + "/completions")
      res = Net::HTTP.post(uri, body.to_json, headers())

      result = JSON.parse(res.body)
      result["choices"][0]["text"]
    end

    private

    def base_url()
      @base_url ||= ENV["OPEN_AI_API_URL"]
    end

    def headers()
      @headers ||= {
        "Content-Type" => "application/json",
        "Authorization" => "Bearer #{ENV["OPEN_AI_API_KEY"]}",
      }
    end
  end
end
