# frozen_string_literal: true

module Form
  class FieldErrorsComponent < ApplicationComponent
    # @param errors [Array<ActiveModel::Error>]
    # @param html_options [Hash]
    def initialize(errors:, **html_options)
      super()

      @errors       = errors
      @html_options = apply_css_class(html_options, 'invalid-feedback')
    end

    # @return [Boolean]
    def render?
      @errors.any?
    end
  end
end
