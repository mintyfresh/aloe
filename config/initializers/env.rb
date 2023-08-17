# frozen_string_literal: true

ENV.class_eval do
  DISABLED_VALUES = %w[false f no n 0].freeze

  # @param key [String, Symbol]
  # @return [Boolean]
  def enabled?(key)
    (value = self[key]).present? && DISABLED_VALUES.exclude?(value.to_s.downcase)
  end
end
