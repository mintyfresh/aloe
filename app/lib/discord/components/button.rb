# frozen_string_literal: true

module Discord
  module Components
    class Button < Base
      TYPE = 2

      STYLES = {
        primary:   1,
        secondary: 2,
        success:   3,
        danger:    4,
        link:      5
      }.freeze

      # @yieldparam interaction [Hash]
      # @yieldparam record_id [Integer, nil]
      # @yieldreturn [Hash]
      # @return [void]
      def self.on_button_interaction(&)
        define_singleton_method(:respond_to_interaction, &)
      end

      has_field_macro :label, required: true
      has_field_macro :style, required: true
      has_field_macro :url
      has_field_macro :disabled
      has_link_to_record

      # @return [Hash]
      def render
        { type: TYPE, label:, style: STYLES.fetch(style), custom_id:, url:, disabled: }.compact
      end

    protected

      # @return [String, nil]
      def custom_id
        Discord::Components.encode_custom_id(self, linked_record) if url.blank?
      end
    end
  end
end
