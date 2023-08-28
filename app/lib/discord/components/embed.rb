# frozen_string_literal: true

module Discord
  module Components
    class Embed < Base
      TYPE = 'rich'

      has_field_macro :title
      has_field_macro :description
      has_field_macro :footer

      # @return [Array<Proc>]
      def self.fields
        @fields ||= []
      end

      # @param name [String, nil]
      # @return [void]
      def self.field(name = nil, **, &)
        fields << lambda do |context|
          embed = Field.new(name:, **)
          embed.instance_eval(&) if block_given?

          embed.render(context)
        end
      end

      # @return [Hash]
      def render
        { type: TYPE, title:, description:, fields:, footer: (text = footer) && { text: } }.compact
      end

    protected

      # @return [Array<Hash>]
      def fields
        self.class.fields.map { |field| field.call(self) }.reject { |field| field[:value].nil? }
      end
    end
  end
end
