# frozen_string_literal: true

module Accordion
  class ItemComponent < ApplicationComponent
    # @return [String, nil]
    attr_reader :parent_id
    # @return [String]
    attr_reader :header_id
    # @return [String]
    attr_reader :collapse_id
    # @return [Boolean]
    attr_reader :expanded
    # @return [Hash]
    attr_reader :html_options

    renders_one :header, lambda { |**options, &block|
      HeaderComponent.new(**options, id: header_id, collapse_id:, expanded:, &block)
    }
    renders_one :body, lambda { |**options, &block|
      BodyComponent.new(**options, id: collapse_id, header_id:, parent_id:, expanded:, &block)
    }

    # @param parent_id [String, nil]
    # @param header_id [String, nil]
    # @param collapse_id [String, nil]
    # @param expanded [Boolean]
    # @param html_options [Hash]
    def initialize(parent_id: nil, header_id: nil, collapse_id: nil, expanded: false, **html_options)
      super()

      @parent_id    = parent_id
      @header_id    = header_id || SecureRandom.uuid
      @collapse_id  = collapse_id || SecureRandom.uuid
      @expanded     = expanded
      @html_options = html_options
    end

    # @return [Array<String>]
    def css_class
      ['accordion-item', *html_options[:class]]
    end
  end
end
