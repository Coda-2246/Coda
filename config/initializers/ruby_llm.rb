require "ruby_llm/schema"

RubyLLM.configure do |config|
  config.anthropic_api_key = ENV["ANTHROPIC_API_KEY"]
  config.default_model = "claude-sonnet-4-5"
  config.use_new_acts_as = true
end
