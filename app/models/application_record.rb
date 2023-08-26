# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  extend HasUniqueAttribute

  primary_abstract_class

  # @param attribute [Symbol]
  # @param error [Symbol]
  # @param options [Hash]
  # @return [ApplicationRecord]
  def self.build_with_error(attribute, error, **options)
    new.tap { |record| record.errors.add(attribute, error, **options) }
  end
end
