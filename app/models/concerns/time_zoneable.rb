# frozen_string_literal: true

module TimeZoneable
  extend ActiveSupport::Concern

  class_methods do
    # @param name [Symbol] the attribute to validate
    # @param required [Boolean] whether the attribute is required
    # @return [void]
    def has_time_zone(name = :time_zone, required: true) # rubocop:disable Naming/PredicateName
      validates(name, presence: true) if required

      validate if: -> { self[name].present? } do
        ActiveSupport::TimeZone[self[name]] or errors.add(name, :invalid)
      end

      define_method(name) do
        (value = super()).presence && ActiveSupport::TimeZone[value]
      end

      define_method("#{name}=") do |value|
        if value.is_a?(ActiveSupport::TimeZone)
          super(value.name)
        else
          super(value)
        end
      end
    end

    # @param names [Array<Symbol>] the name of the date-time attribute
    # @param time_zone [Symbol] the name of the time zone attribute
    # @return [void]
    def has_date_time_in_time_zone(*names, time_zone: :time_zone) # rubocop:disable Naming/PredicateName
      names.each do |name|
        define_method(name) do |*args, without_time_zone: false, **kwargs, &block|
          value = super(*args, **kwargs, &block)
          return value if value.blank?

          time_zone_value = public_send(time_zone) || Time.zone
          return value if time_zone_value.blank? || without_time_zone

          value.in_time_zone(time_zone_value)
        end
      end
    end
  end
end
