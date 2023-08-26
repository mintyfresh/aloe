# frozen_string_literal: true

module Discord
  module Components
    class Modal < Base
      TYPE = 9

      # @yieldparam interaction [Hash]
      # @yieldparam record_id [Integer, nil]
      # @yieldparam attributes [Hash{Symbol => String}]
      # @yieldreturn [Hash]
      # @return [void]
      def self.on_modal_submit
        define_singleton_method(:respond_to_interaction) do |interaction, record_id|
          attributes = interaction.dig('data', 'components').pluck('components').flatten.to_h do |component|
            [component['custom_id'], component['value']]
          end

          yield(interaction, record_id, attributes)
        end
      end

      # @overload title(title)
      #   @param title [String]
      #   @return [void]
      # @overload title(&)
      #   @yieldreturn [String]
      #   @return [void]
      def self.title(title = nil, &)
        if block_given?
          define_method(:title, &)
        elsif title.is_a?(String)
          define_method(:title) { title }
        else
          raise ArgumentError, "must provide a String or a block"
        end
      end

      # @yieldreturn [ApplicationRecord]
      # @return [void]
      def self.link_to_record(&)
        define_method(:link_to_record, &)
      end

      # @return [Array<Proc>]
      def self.components
        @components ||= []
      end

      # @param label [String]
      # @param custom_id [String]
      # @param style [Symbol]
      # @param options [Hash]
      # @return [void]
      def self.text_input(label, custom_id: label.to_s.underscore, style: :short, **options, &)
        components << -> (context) {
          text_input = TextInput.new(label:, custom_id:, style:, **options)
          text_input.instance_eval(&) if block_given?

          text_input.render(context)
        }
      end

      # @return [Hash]
      def render
        { type: TYPE, data: { title:, custom_id:, components: } }
      end

    protected

      # @abstract
      # @return [String]
      def title
        raise NotImplementedError, "#{self.class.name} must define a title."
      end

      # @return [String, nil]
      def custom_id
        Discord::Components.encode_custom_id(self, link_to_record)
      end

      # @return [ApplicationRecord, nil]
      def link_to_record
        nil
      end

      # @return [Array<Hash>]
      def components
        self.class.components.map do |proc|
          { type: 1, components: [proc.call(self)] }
        end
      end
    end
  end
end
