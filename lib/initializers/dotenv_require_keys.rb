require_relative "../modules/os"

if OS.windows?
  module Dotenv
    class Error < StandardError; end

    class MissingKeys < Error # :nodoc:
      def initialize(keys)
        key_word = "key#{keys.size > 1 ? "s" : ""}"
        super("Missing required configuration #{key_word}: #{keys.inspect}")
      end
    end

    module_function

    def require_keys(*keys)
      missing_keys = keys.flatten - ::ENV.keys
      return if missing_keys.empty?
      raise MissingKeys, missing_keys
    end
  end
end
