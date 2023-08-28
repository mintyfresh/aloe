# frozen_string_literal: true

module Discord
  module Components
    class TextInput < Base
      TYPE = 4

      STYLES = {
        short: 1,
        long:  2
      }.freeze

      SUPPORTED_ATTRIBUTES = %i[
        label
        custom_id
        style
        min_length
        max_length
        required
        placeholder
        value
      ].freeze

      # @param attributes [Hash{Symbol => String, Integer, Boolean, Proc}]
      def initialize(**attributes)
        super()

        attributes.assert_valid_keys(*SUPPORTED_ATTRIBUTES)
        @attributes = attributes
      end

      # @param context [Object]
      # @return [Hash]
      def render(context)
        attributes = renderable_attributes.transform_values do |value|
          value.is_a?(Proc) ? context.instance_eval(&value) : value
        end

        attributes[:style] &&= STYLES.fetch(attributes[:style])
        attributes.merge(type: TYPE)
      end

      # A Hash of attributes to be rendered in a context.
      # Procs remain un-evaluated, but unset attributes are omitted.
      #
      # @return [Hash{Symbol => String, Integer, Boolean, Proc}]
      def renderable_attributes
        SUPPORTED_ATTRIBUTES
          .select { |attribute| @attributes.key?(attribute) }
          .index_with { |attribute| @attributes[attribute] }
      end

      # Marks the text input as optional.
      #
      # @return [void]
      def optional!
        required false
      end

      # Marks the text input as required.
      #
      # @return [void]
      def required!
        required true
      end

      SUPPORTED_ATTRIBUTES.each do |attribute|
        define_method(attribute) do |value = :__unspecified__, &block|
          if block.present?
            @attributes[attribute] = block
          elsif value != :__unspecified__
            @attributes[attribute] = value
          else
            raise ArgumentError, 'must provide a value or a block'
          end
        end
      end
    end
  end
end
