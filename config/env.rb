# frozen_string_literal: true

class << ENV
  DISABLED_VALUES = %w[false f no n 0].freeze
end

# @param key [String, Symbol]
# @return [Boolean]
def ENV.enabled?(key)
  (value = self[key]).present? && DISABLED_VALUES.exclude?(value.to_s.downcase)
end

# @param key [String, Symbol]
# @return [String]
def ENV.require(key)
  self[key].presence or raise KeyError, "Missing ENV[#{key.inspect}]"
end
