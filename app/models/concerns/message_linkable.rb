# frozen_string_literal: true

module MessageLinkable
  extend ActiveSupport::Concern

  class_methods do
    # @param name [Symbol]
    # @param dependent [Symbol]
    # @return [void]
    def has_linked_message(name, dependent: :destroy)
      class_name = "#{name.to_s.camelize}MessageLink"

      model_class = const_set(class_name, Class.new(MessageLink))
      model_class.belongs_to :linkable, inverse_of: :"#{name}_message_link", polymorphic: true

      has_one :"#{name}_message_link", -> { where(name:) },
              as: :linkable, class_name:, dependent:, inverse_of: :linkable
      has_one :"#{name}_message", through: :"#{name}_message_link", source: :message
    end
  end
end
