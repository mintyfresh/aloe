# frozen_string_literal: true

module Discord
  module Components
    class Base
      # @return [Hash]
      def self.render(...)
        new(...).render
      end

      # @param name [Symbol]
      # @param required [Boolean]
      # @return [void]
      def self.has_field_macro(name, required: false) # rubocop:disable Naming/PredicateName
        define_singleton_method(name) do |value = :__unspecified__, &block|
          if block.present?
            define_method(name, &block)
          elsif value != :__unspecified__
            define_method(name) { value }
          elsif required
            raise ArgumentError, 'must provide a value or a block'
          end
        end

        define_method(name) do
          raise NotImplementedError, "#{self.class.name} must define a #{name}" if required
        end
      end

      # @return [void]
      def self.has_link_to_record # rubocop:disable Naming/PredicateName
        define_singleton_method(:links_to_record) do |&block|
          define_method(:linked_record, &block)
        end

        define_method(:linked_record) { nil }
        define_method(:custom_id) { Discord::Components.encode_custom_id(self, linked_record) }
      end

      # @abstract
      # @return [Hash]
      def render
        raise NotImplementedError, "#{self.class.name}#render is not implemented"
      end
    end
  end
end
