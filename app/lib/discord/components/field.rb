# frozen_string_literal: true

module Discord
  module Components
    class Field < Base
      SUPPORTED_ATTRIBUTES = %i[
        name
        value
        inline
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
        renderable_attributes.transform_values do |value|
          value.is_a?(Proc) ? context.instance_eval(&value) : value
        end
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

      # @return [Boolean]
      def inline!
        inline true
      end

      SUPPORTED_ATTRIBUTES.each do |attribute|
        define_method(attribute) do |value = :__unspecified__, &block|
          if block.present?
            @attributes[attribute] = block
          elsif value != :__unspecified__
            @attributes[attribute] = value
          else
            raise ArgumentError, "must provide `#{attribute}` with a value or a block"
          end
        end
      end
    end
  end
end
