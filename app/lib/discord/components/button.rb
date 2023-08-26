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

      # @overload label(label)
      #   @param label [String]
      #   @return [void]
      # @overload label(&block)
      #   @yieldreturn [String]
      #   @return [void]
      def self.label(label = nil, &)
        if block_given?
          define_method(:label, &)
        elsif label.is_a?(String)
          define_method(:label) { label }
        else
          raise ArgumentError, "must provide a String or a block"
        end
      end

      # @overload style(style)
      #   @param style [Symbol]
      #   @return [void]
      # @overload style(&block)
      #   @yieldreturn [Symbol]
      #   @return [void]
      def self.style(style = nil, &)
        if block_given?
          define_method(:style, &)
        elsif style.is_a?(Symbol)
          define_method(:style) { style }
        else
          raise ArgumentError, "must provide a Symbol or a block"
        end
      end

      # @yieldreturn [ApplicationRecord]
      # @return [void]
      def self.link_to_record(&)
        define_method(:link_to_record, &)
      end

      # @overload url(url)
      #   @param url [String]
      #   @return [void]
      # @overload url(&block)
      #   @yieldreturn [String]
      #   @return [void]
      def self.url(url = nil, &)
        if block_given?
          define_method(:url, &)
        elsif url.is_a?(String)
          define_method(:url) { url }
        else
          raise ArgumentError, "must provide a String or a block"
        end
      end

      # @overload disabled(disabled)
      #   @param disabled [Boolean]
      #   @return [void]
      # @overload disabled(&block)
      #   @yieldreturn [Boolean]
      #   @return [void]
      def self.disabled(disabled = nil, &)
        if block_given?
          define_method(:disabled, &)
        elsif [true, false].include?(disabled)
          define_method(:disabled) { disabled }
        else
          raise ArgumentError, "must provide a Boolean or a block"
        end
      end

      # @return [Hash]
      def render
        { type: TYPE, label:, style: STYLES.fetch(style), custom_id:, url:, disabled: }.compact
      end

      # @abstract
      # @return [String]
      def label
        raise NotImplementedError, "#{self.class.name} must define a label"
      end

      # @abstract
      # @return [Symbol]
      def style
        raise NotImplementedError, "#{self.class.name} must define a style"
      end

      # @return [String, nil]
      def custom_id
        Discord::Components.encode_custom_id(self, link_to_record) if url.blank?
      end

      # @return [ApplicationRecord, nil]
      def link_to_record
        nil
      end

      # @return [String, nil]
      def url
        nil
      end

      # @return [Boolean, nil]
      def disabled
        nil
      end
    end
  end
end
