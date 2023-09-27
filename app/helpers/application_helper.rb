# frozen_string_literal: true

module ApplicationHelper
  def form_with(**options, &)
    super(builder: ApplicationFormBuilder, **options, &)
  end

  # Given an options Hash for a Rails view helper, apply the given CSS classes.
  #
  # @param options [Hash]
  # @param classes [Array<String>]
  # @return [Hash]
  def apply_css_class(options, *classes)
    options.merge(class: [*options[:class], *classes])
  end

  # Constructs a bootstrap nav-link elements with the given label and path.
  # Automatically applies the 'active' CSS class if the current page matches the given path.
  #
  # @param label [String]
  # @param path [String]
  # @param options [Hash]
  # @return [String]
  def nav_link_to(label, path, **options, &)
    options = apply_css_class(options, 'nav-link')

    if current_page?(path)
      options = apply_css_class(options, 'active')
      options = options.deep_merge(aria: { current: 'page' })
    end

    tag.li(class: 'nav-item') do
      link_to(label, path, options, &)
    end
  end

  # Constructs a bootstrap nav-link elements with the given label and path.
  # Unlike {#nav_link_to}, this method constructs a button instead of a link.
  #
  # @param label [String]
  # @param path [String]
  # @param options [Hash]
  # @return [String]
  def nav_button_to(label, path, **options, &)
    options = apply_css_class(options, 'nav-link')

    tag.li(class: 'nav-item') do
      button_to(label, path, options, &)
    end
  end
end
