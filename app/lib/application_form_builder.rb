# frozen_string_literal: true

class ApplicationFormBuilder < ActionView::Helpers::FormBuilder
  # @param options [Hash]
  # @return [String]
  def group(**options, &)
    @template.content_tag(:div, apply_css_class(options, 'mb-3'), &)
  end

  # @param method [Symbol]
  # @param text [String]
  # @param options [Hash]
  # @return [String]
  def label(method, text = nil, **options, &)
    super(method, text, apply_css_class(options, 'form-label'), &)
  end

  # @param method [Symbol]
  # @param has_help_text [Boolean, String]
  # @param options [Hash]
  # @return [String]
  def text_field(method, has_help_text: false, **options)
    options = apply_css_class(options, 'form-control')
    options = apply_help_text(options, has_help_text, method) if has_help_text

    super(method, options)
  end

  # @param method [Symbol]
  # @param has_help_text [Boolean, String]
  # @param options [Hash]
  # @return [String]
  def text_area(method, has_help_text: false, **options)
    options = apply_css_class(options, 'form-control')
    options = apply_help_text(options, has_help_text, method) if has_help_text

    super(method, options)
  end

  # @param method [Symbol]
  # @param has_help_text [Boolean, String]
  # @param options [Hash]
  # @return [String]
  def number_field(method, has_help_text: false, **options)
    options = apply_css_class(options, 'form-control')
    options = apply_help_text(options, has_help_text, method) if has_help_text

    super(method, options)
  end

  # @param method [Symbol]
  # @param has_help_text [Boolean, String]
  # @param options [Hash]
  # @return [String]
  def date_field(method, has_help_text: false, **options)
    options = apply_css_class(options, 'form-control')
    options = apply_help_text(options, has_help_text, method) if has_help_text

    super(method, options)
  end

  # @param method [Symbol]
  # @param has_help_text [Boolean, String]
  # @param options [Hash]
  # @return [String]
  def datetime_field(method, has_help_text: false, **options)
    options = apply_css_class(options, 'form-control')
    options = apply_help_text(options, has_help_text, method) if has_help_text

    super(method, options)
  end

  # @param method [Symbol]
  # @param has_help_text [Boolean, String]
  # @param options [Hash]
  # @return [String]
  def color_field(method, has_help_text: false, **options)
    options = apply_css_class(options, 'form-control', 'form-control-color')
    options = apply_help_text(options, has_help_text, method) if has_help_text

    super(method, options)
  end

  alias colour_field color_field

  # @param method [Symbol]
  # @param choices [Array<String>, nil]
  # @param options [Hash]
  # @param has_help_text [Boolean, String]
  # @param html_options [Hash]
  # @return [String]
  def select(method, choices = nil, options = {}, has_help_text: false, **html_options, &)
    html_options = apply_css_class(html_options, 'form-select')
    html_options = apply_help_text(html_options, has_help_text, method) if has_help_text

    super(method, choices, options, html_options, &)
  end

  # @param method [Symbol]
  # @param priority_zones [Array<String>, nil]
  # @param options [Hash]
  # @param has_help_text [Boolean, String]
  # @param html_options [Hash]
  # @return [String]
  def time_zone_select(method, priority_zones = nil, options = {}, has_help_text: false, **html_options)
    html_options = apply_css_class(html_options, 'form-select')
    html_options = apply_help_text(html_options, has_help_text, method) if has_help_text

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
  def help_text(method, text = nil, **options, &)
    options = options.merge(id: help_text_id(method)) unless options[:id]
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
  def submit(value = nil, **options)
    super(value, apply_css_class(options, 'btn', 'btn-primary'))
  end

  # @param html_options [Hash]
  # @return [String]
  def base_errors(**)
    object && @template.render(Form::BaseErrorsComponent.new(errors: object.errors[:base], **))
  end

  # @param method [Symbol]
  # @param html_options [Hash]
  # @return [String]
  def field_errors(method, **)
    object && @template.render(Form::FieldErrorsComponent.new(errors: object.errors[method], **))
  end

private

  # @param options [Hash]
  # @param css_classes [Array<String>]
  # @return [Hash]
  def apply_css_class(options, *css_classes)
    options.merge(class: [*options[:class], *css_classes].uniq.join(' '))
  end

  # @param options [Hash]
  # @param help_text_id [String]
  # @return [Hash]
  def apply_help_text(options, has_help_text, method)
    apply_aria(options, describedby: has_help_text.is_a?(String) ? has_help_text : help_text_id(method))
  end

  # @param options [Hash]
  # @param aria [Hash]
  # @return [Hash]
  def apply_aria(options, **aria)
    options.deep_merge(aria:)
  end
end
