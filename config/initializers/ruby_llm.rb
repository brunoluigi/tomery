# frozen_string_literal: true

# RubyLLM Configuration
# See: https://github.com/crmne/ruby_llm

RubyLLM.configure do |config|
  # OpenAI Configuration
  # Set via Rails credentials: rails credentials:edit
  # Add: openai: { api_key: your_api_key }
  config.openai_api_key = Rails.application.credentials.dig(:openai, :api_key)

  # Anthropic Configuration (optional)
  # Add: anthropic: { api_key: your_api_key }
  config.anthropic_api_key = Rails.application.credentials.dig(:anthropic, :api_key)

  # Google Gemini Configuration (optional)
  # Add: google: { api_key: your_gemini_api_key }
  config.gemini_api_key = Rails.application.credentials.dig(:google, :gemini_api_key)

  # Default model to use
  # config.default_model = "gpt-4o-mini"

  # Request timeout in seconds
  # config.request_timeout = 120

  # Maximum retries on failure
  # config.max_retries = 3
end
