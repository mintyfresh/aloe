# frozen_string_literal: true

class ApplicationFormBuilder < ActionView::Helpers::FormBuilder
  # @param options [Hash]
  # @return [String]
  def group(options = {}, &)
    @template.content_tag(:div, apply_css_class(options, 'mb-3'), &)
  end

  # @param method [Symbol]
  # @param text [String]
  # @param options [Hash]
  # @return [String]
  def label(method, text = nil, options = {}, &)
    super(method, text, apply_css_class(options, 'form-label'), &)
  end

  # @param method [Symbol]
  # @param options [Hash]
  # @return [String]
  def text_field(method, options = {})
    options = apply_css_class(options, 'form-control')
    options = apply_css_class(options, 'is-invalid') if field_invalid?(method)

    super(method, options)
  end

  # @param method [Symbol]
  # @param options [Hash]
  # @return [String]
  def text_area(method, options = {})
    options = apply_css_class(options, 'form-control')
    options = apply_css_class(options, 'is-invalid') if field_invalid?(method)

    super(method, options)
  end

  # @param method [Symbol]
  # @param options [Hash]
  # @return [String]
  def number_field(method, options = {})
    options = apply_css_class(options, 'form-control')
    options = apply_css_class(options, 'is-invalid') if field_invalid?(method)

    super(method, options)
  end

  # @param method [Symbol]
  # @param options [Hash]
  # @return [String]
  def date_field(method, options = {})
    options = apply_css_class(options, 'form-control')
    options = apply_css_class(options, 'is-invalid') if field_invalid?(method)

    super(method, options)
  end

  # @param method [Symbol]
  # @param options [Hash]
  # @return [String]
  def datetime_field(method, options = {})
    options = apply_css_class(options, 'form-control')
    options = apply_css_class(options, 'is-invalid') if field_invalid?(method)

    super(method, options)
  end

  # @param method [Symbol]
  # @param options [Hash]
  # @return [String]
  def color_field(method, options = {})
    options = apply_css_class(options, 'form-control', 'form-control-color')
    options = apply_css_class(options, 'is-invalid') if field_invalid?(method)

    super(method, options)
  end

  alias colour_field color_field

  # @param method [Symbol]
  # @param choices [Array<String>, nil]
  # @param options [Hash]
  # @param html_options [Hash]
  # @return [String]
  def select(method, choices = nil, options = {}, html_options = {}, &)
    html_options = apply_css_class(html_options, 'form-select')
    html_options = apply_css_class(html_options, 'is-invalid') if field_invalid?(method)

    super(method, choices, options, html_options, &)
  end

  # @param method [Symbol]
  # @param priority_zones [Array<String>, nil]
  # @param options [Hash]
  # @param html_options [Hash]
  # @return [String]
  def time_zone_select(method, priority_zones = nil, options = {}, html_options = {})
    html_options = apply_css_class(html_options, 'form-select')
    html_options = apply_css_class(html_options, 'is-invalid') if field_invalid?(method)

    super(method, priority_zones, options, html_options)
  end

  # @param method [Symbol]
  # @param options [Hash]
  # @param checked_value [String]
  # @param unchecked_value [String]
  # @return [String]
  def check_box(method, options = {}, checked_value = '1', unchecked_value = '0')
    super(method, apply_css_class(options, 'form-check-input'), checked_value, unchecked_value)
  end

  # @param method [Symbol]
  # @param options [Hash]
  # @param label_options [Hash]
  # @param wrapper_options [Hash]
  # @return [String]
  def check(method, options = {}, label_options = {}, wrapper_options = {})
    @template.content_tag(:div, apply_css_class(wrapper_options, 'form-check')) do
      check_box(method, options) + label(method, apply_css_class(label_options, 'form-check-label'))
    end
  end

  # @param method [Symbol]
  # @param options [Hash]
  # @param label_options [Hash]
  # @param wrapper_options [Hash]
  # @return [String]
  def switch(method, options = {}, label_options = {}, wrapper_options = {})
    check(method, options.merge(role: 'switch'), label_options, apply_css_class(wrapper_options, 'form-switch'))
  end

  # @param method [Symbol]
  # @param options [Hash]
  # @param label_options [Hash]
  # @return [String]
  def help_text(method, text = nil, options = {}, &)
    options = options.merge(id: help_text_id(method))
    options = apply_css_class(options, 'form-text')

    @template.content_tag(:div, text, options, &)
  end

  # @param method [Symbol]
  # @return [String]
  def help_text_id(method)
    field_id(method, :help_text)
  end

  # @param value [String]
  # @param options [Hash]
  # @return [String]
  def submit(value = nil, options = {})
    super(value, apply_css_class(options, 'btn', 'btn-primary'))
  end

private

  # @param options [Hash]
  # @param css_classes [Array<String>]
  # @return [Hash]
  def apply_css_class(options, *css_classes)
    options.merge(class: [*options[:class], *css_classes].uniq.join(' '))
  end

  # @param method [Symbol]
  # @return [Boolean]
  def field_invalid?(method)
    return false unless object.respond_to?(:errors)
    return true if object.errors.where(method).any?

    method = method.to_s

    if method.ends_with?('_ids')
      method = method.chomp('_ids').pluralize
    elsif method.ends_with?('_id')
      method = method.chomp('_id')
    end

    object.errors.where(method).any?
  end
end
