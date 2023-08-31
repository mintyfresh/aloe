# frozen_string_literal: true

module Discord
  module Linkable
    extend ActiveSupport::Concern

    class_methods do
      # @param name [Symbol]
      # @param type [Symbol]
      # @param class_name [String]
      # @param dependent [Symbol]
      # @param required [Boolean]
      # @return [void]
      def has_linked_discord_record(name = :discord, type, class_name: "Discord::#{type.to_s.camelize}", dependent: :destroy, required: false) # rubocop:disable Naming/PredicateName
        link_class_name = "#{name.to_s.camelize}#{type.to_s.camelize}Link".camelize

        model_class = const_set(link_class_name, Class.new(Discord::RecordLink))
        model_class.belongs_to :linkable, inverse_of: :"#{name}_#{type}_link", polymorphic: true
        model_class.belongs_to :record, class_name:, inverse_of: false

        has_one :"#{name}_#{type}_link", -> { where(name:) },
                as: :linkable, class_name: link_class_name, dependent:, inverse_of: :linkable
        has_one :"#{name}_#{type}", through: :"#{name}_#{type}_link", source: :record

        validates :"#{name}_#{type}", presence: true if required
      end
    end
  end
end
