# frozen_string_literal: true

module Form
  class BaseErrorsComponent < ApplicationComponent
    # @param errors [Array<ActiveModel::Error>]
    # @param variant [String]
    # @param html_options [Hash]
    def initialize(errors:, variant: 'danger', **html_options)
      super()

      @errors       = errors
      @html_options = apply_css_class(html_options, 'alert', "alert-#{variant}")
    end

    # @return [Boolean]
    def render?
      @errors.any?
    end
  end
end