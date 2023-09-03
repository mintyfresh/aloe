# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  extend HasUniqueAttribute

  include HasMoreSecureToken

  primary_abstract_class

  # @param attribute [String, Symbol]
  # @param value [Object]
  # @param type [ActiveRecord::Type::Value]
  # @return [Arel::Nodes::BindParam]
  def self.bind_param(attribute, value, type: ActiveRecord::Type::Value.new)
    Arel::Nodes::BindParam.new(ActiveRecord::Relation::QueryAttribute.new(attribute.to_s, value, type))
  end

  # @param attribute [Symbol]
  # @param error [Symbol]
  # @param options [Hash]
  # @return [ApplicationRecord]
  def self.build_with_error(attribute, error, **)
    new.tap { |record| record.errors.add(attribute, error, **) }
  end
end
