# frozen_string_literal: true

module Discord
  module Linkable
    extend ActiveSupport::Concern

    class_methods do
      # @param name [Symbol]
      # @param dependent [Symbol]
      # @param required [Boolean]
      # @return [void]
      def has_linked_discord_record(name, dependent: :destroy, required: false) # rubocop:disable Naming/PredicateName
        has_one :"#{name}_link", -> { where(name:) }, autosave: true, as: :linkable,
                class_name: 'Discord::RecordLink', dependent:, inverse_of: :linkable

        validates :"#{name}_id", presence: true if required

        define_method(:"#{name}_id") do
          send(:"#{name}_link")&.record_id
        end

        define_method(:"#{name}_id=") do |id|
          link = send(:"#{name}_link")

          if id.present?
            link ||= send(:"build_#{name}_link")
            link.record_id = id
          else
            link&.mark_for_destruction
            link&.record_id = nil
          end
        end
      end
    end
  end
end
