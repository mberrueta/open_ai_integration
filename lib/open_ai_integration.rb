# frozen_string_literal: true

require_relative "open_ai_integration/version"
require_relative "open_ai_integration/test_generation"
require_relative "http/open_ai_client"

module OpenAiIntegration
  class Error < StandardError; end
end
