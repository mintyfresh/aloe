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

      has_field_macro :title, required: true
      has_link_to_record

      # @return [Array<Proc>]
      def self.components
        @components ||= []
      end

      # @param label [String]
      # @param custom_id [String]
      # @param style [Symbol]
      # @param options [Hash]
      # @return [void]
      def self.text_input(label, custom_id: label.to_s.underscore, style: :short, **, &)
        components << proc do |context|
          text_input = TextInput.new(label:, custom_id:, style:, **)
          text_input.instance_eval(&) if block_given?

          text_input.render(context)
        end
      end

      # @return [Hash]
      def render
        { type: TYPE, data: { title:, custom_id:, components: } }
      end

    protected

      # @return [Array<Hash>]
      def components
        self.class.components.map do |proc|
          { type: 1, components: [proc.call(self)] }
        end
      end
    end
  end
end
