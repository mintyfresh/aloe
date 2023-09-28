# frozen_string_literal: true

class Event
  class CheckInConfigFieldsComponent < ApplicationComponent
    # @param form [ActionView::Helpers::FormBuilder]
    def initialize(form:)
      super()

      @form = form
    end
  end
end
