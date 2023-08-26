# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  extend HasUniqueAttribute

  primary_abstract_class

  # @param name [Symbol, String]
  # @param value [Object]
  # @param type [ActiveRecord::Type::Value]
  # @return [Arel::Nodes::BindParam]
  def self.bind_param(name, value, type: ActiveRecord::Type::Value.new)
    Arel::Nodes::BindParam.new(ActiveRecord::Relation::QueryAttribute.new(name.to_s, value, type))
  end

  # @param attribute [Symbol]
  # @param error [Symbol]
  # @param options [Hash]
  # @return [ApplicationRecord]
  def self.build_with_error(attribute, error, **options)
    new.tap { |record| record.errors.add(attribute, error, **options) }
  end
end
