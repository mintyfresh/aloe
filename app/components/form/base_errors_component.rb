# frozen_string_literal: true

module Form
  class BaseErrorsComponent < ApplicationComponent
    # @param errors [Array<ActiveModel::Error>]
    # @param html_options [Hash]
    def initialize(errors:, **html_options)
      super()

      @errors       = errors
      @html_options = html_options
    end

    # @return [Boolean]
    def render?
      @errors.any?
    end
  end
end
