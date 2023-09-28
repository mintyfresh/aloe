# frozen_string_literal: true

class Event
  class PriceConfigFieldsComponent < ApplicationComponent
    # @param form [ActionView::Helpers::FormBuilder]
    def initialize(form:)
      super()

      @form = form
    end

    # @return [Hash{String => String}]
    def currencies
      @currencies ||= Money::Currency.table.transform_keys(&:upcase).transform_values { |value| value[:iso_code] }
    end
  end
end
