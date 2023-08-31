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
        link_name = "#{name}_#{type}"
        link_class_name = "#{name.to_s.camelize}#{type.to_s.camelize}Link".camelize

        model_class = const_set(link_class_name, Class.new(Discord::RecordLink))
        model_class.belongs_to :linkable, inverse_of: :"#{name}_#{type}_link", polymorphic: true
        model_class.belongs_to :record, class_name:, inverse_of: false

        has_one :"#{link_name}_link", -> { where(name: link_name) },
                as: :linkable, class_name: link_class_name, dependent:, inverse_of: :linkable
        has_one :"#{link_name}", through: :"#{link_name}_link", source: :record

        validates :"#{link_name}", presence: true if required

        define_method(:"#{link_name}_id") do
          send(:"#{link_name}")&.id
        end

        define_method(:"#{link_name}_id=") do |id|
          send(:"#{link_name}=", class_name.constantize.find(id))
        end
      end
    end
  end
end
