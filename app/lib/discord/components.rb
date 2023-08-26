# frozen_string_literal: true

module Discord
  module Components
    # @param component [Discord::Components::Base]
    # @param record [ApplicationRecord, nil]
    # @return [String]
    def self.encode_custom_id(component, record = nil)
      [component.class.name.demodulize, record&.id].compact.join('/')
    end

    # @param custom_id [String]
    # @return [(Class<Discord::Components::Base>, Integer), nil]
    def self.decode_custom_id(custom_id)
      component_class, record_id = custom_id.split('/', 2)
      component_class = "Discord::Components::#{component_class}".safe_constantize
      raise unless component_class.is_a?(Class) && component_class < Base

      [component_class, record_id&.to_i]
    end

    # @param interaction [Hash]
    # @return [Hash]
    def self.respond_to_interaction(interaction)
      custom_id = interaction.dig('data', 'custom_id')
      return if custom_id.blank?

      component_class, record_id = decode_custom_id(custom_id)
      return if component_class.nil?

      component_class.try(:respond_to_interaction, interaction, record_id)
    end
  end
end
