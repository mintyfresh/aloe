# frozen_string_literal: true

class DatetimeValidator < ActiveModel::EachValidator
  COMPARISONS = {
    after:        -> (value, boundary) { value > boundary },
    before:       -> (value, boundary) { value < boundary },
    at_or_after:  -> (value, boundary) { value >= boundary },
    at_or_before: -> (value, boundary) { value <= boundary },
    at:           -> (value, boundary) { value == boundary }
  }.freeze

  # @param record [ActiveRecord::Base, ActiveModel::Model]
  # @param attribute [Symbol]
  # @param value [Object]
  # @return [void]
  def validate_each(record, attribute, value)
    if value.nil?
      allow_nil? or record.errors.add(attribute, :blank)
      return
    end

    value = type.cast(value)

    COMPARISONS.each do |name, comparator|
      if (boundary = extract_boundary(record, name))
        comparator.call(value, type.cast(boundary)) or record.errors.add(attribute, :"must_be_#{name}", time: boundary)
      end
    end
  end

private

  # @return [Boolean]
  def allow_nil?
    options.fetch(:allow_nil, false)
  end

  # @return [ActiveRecord::Type::Value]
  def type
    @type ||= ActiveRecord::Type.lookup(options.fetch(:type, :datetime))
  end

  # @param record [ActiveRecord::Base, ActiveModel::Model]
  # @param name [Symbol]
  # @return [ActiveSupport::TimeWithZone, Time]
  def extract_boundary(record, name)
    case options[name]
    in String | Symbol => locator
      record.public_send(locator)
    in Proc => block
      record.instance_exec(&block)
    in nil
      nil
    else
      raise TypeError, "Invalid value for #{name.inspect}: #{options[name].inspect}. " \
                       '(Must be a String, Symbol, or Proc.)'
    end
  end
end
