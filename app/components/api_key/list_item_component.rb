# frozen_string_literal: true

class ApiKey
  class ListItemComponent < ApplicationComponent
    # @param api_key [ApiKey]
    # @param current_user [User, nil]
    def initialize(api_key:, current_user:)
      super()

      @api_key      = api_key
      @current_user = current_user
    end

    # @return [String, nil]
    def token
      flash["api_key_#{@api_key.id}"]
    end

    # @return [Array<String>]
    def dropdown_items
      @dropdown_items ||= begin
        items = []

        items << edit_dropdown_item   if Pundit.policy!(@current_user, @api_key).update?
        items << rotate_dropdown_item if Pundit.policy!(@current_user, @api_key).rotate?
        items << revoke_dropdown_item if Pundit.policy!(@current_user, @api_key).revoke?

        items
      end
    end

  private

    # @return [String]
    def edit_dropdown_item
      link_to('Edit', edit_api_key_path(@api_key), class: 'dropdown-item')
    end

    # @return [String]
    def rotate_dropdown_item
      button_to('Generate new key', rotate_api_key_path(@api_key), class: 'dropdown-item', method: :post)
    end

    # @return [String]
    def revoke_dropdown_item
      button_to('Revoke', revoke_api_key_path(@api_key), class: 'dropdown-item text-danger', method: :post)
    end
  end
end
