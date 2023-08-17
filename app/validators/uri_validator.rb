# frozen_string_literal: true

class UriValidator < ActiveModel::EachValidator
  # @param record [ActiveRecord::Base]
  # @param attribute [Symbol]
  # @param value [String, nil]
  def validate_each(record, attribute, value)
    return if value.blank?

    uri = URI.parse(value)

    valid_scheme?(uri.scheme) or record.errors.add(attribute, :invalid_scheme, scheme: schemes.join(', '))
    valid_host?(uri.host)     or record.errors.add(attribute, :invalid_host, host: hosts.join(', '))
    valid_path?(uri.path)     or record.errors.add(attribute, :invalid_path, path: paths.join(', '))
  rescue URI::InvalidURIError
    record.errors.add(attribute, :invalid_uri)
  end

private

  # @return [Array<String>]
  def schemes
    @schemes ||= [*options[:scheme]].map(&:to_s)
  end

  # @return [Array<String>]
  def hosts
    @hosts ||= [*options[:host]].map(&:to_s)
  end

  # @return [Array<String>]
  def paths
    @paths ||= [*options[:path]].map(&:to_s)
  end

  # @param scheme [String, nil]
  # @return [Boolean]
  def valid_scheme?(scheme)
    schemes.blank? || schemes.include?(scheme)
  end

  # @param host [String, nil]
  # @return [Boolean]
  def valid_host?(host)
    hosts.blank? || hosts.include?(host)
  end

  # @param path [String, nil]
  # @return [Boolean]
  def valid_path?(path)
    paths.blank? || paths.include?(path)
  end
end
