# frozen_string_literal: true

module Discord
  module Components
    class EventRegisterModal < Modal
      # @param interaction [Hash] the modal submission interaction
      # @param event_id [Integer]
      # @param attributes [Hash{String => String}]
      on_modal_submit do |interaction, event_id, attributes|
        event = ::Event.find(event_id)
        user  = ::User.upsert_from_discord!(discord_id: interaction.dig('member', 'user', 'id'),
                                            name:       interaction.dig('member', 'user', 'username'))

        registration = event.registrations.create_or_find_by!(user:)
        previously_new_record = registration.previously_new_record?

        if !registration.update(deck_list_attributes: attributes)
          content = format_errors_message(registration.errors, registration.deck_list)
        elsif previously_new_record
          content = format_create_message(event, registration.deck_list)
        elsif registration&.deck_list&.saved_changes?
          content = format_update_message(event, registration.deck_list)
        else
          content = format_no_op_message(event, registration.deck_list)
        end

        { type: 4, data: { content:, flags: 1 << 6 } }
      end

      class << self
      private

        # @param errors [ActiveModel::Errors]
        # @param deck_list [::DeckList, nil]
        # @return [String]
        def format_errors_message(errors, deck_list)
          content  = "Error submitting your deck list:\n"
          content += errors.full_messages.map { |error| "- #{error}" }.join("\n")
          content += "\n\nPlease try again.\n"
          content += "(You're still registered with your existing deck list.)" if deck_list&.persisted?

          content
        end

        # @param event [::Event]
        # @param deck_list [::DeckList, nil]
        # @return [String]
        def format_create_message(event, deck_list)
          "Successfully registered for #{event.name}!\n" + format_deck_list_info(deck_list)
        end

        # @param event [::Event]
        # @param deck_list [::DeckList, nil]
        # @return [String]
        def format_update_message(event, deck_list)
          "Successfully updated your registration for #{event.name}!\n" + format_deck_list_info(deck_list)
        end

        # @param event [::Event]
        # @param deck_list [::DeckList, nil]
        # @return [String]
        def format_no_op_message(event, deck_list)
          "You're already registered for #{event.name}.\n" + format_deck_list_info(deck_list)
        end

        # @param event [::DeckList, nil]
        # @return [String]
        def format_deck_list_info(deck_list)
          return '' if deck_list.nil?

          "Your submitted deck list: [#{deck_list.deck_name || 'Your deck list'}](#{deck_list.pony_head_url})"
        end
      end

      # @param event [::Event]
      # @param interaction [Hash] the button interaction that opened the modal
      def initialize(event, interaction)
        super()

        @event       = event
        @interaction = interaction
      end

      title do
        title = "Register for #{@event.name}"
        title = 'Register for Event' if title.length > 45

        title
      end

      links_to_record do
        @event
      end

      text_input 'Deck List URL (optional)' do
        custom_id 'pony_head_url'
        placeholder 'https://ponyhead.com/deckbuilder?v1code=...'
        optional!

        value do
          registration&.deck_list&.pony_head_url
        end
      end

      text_input 'Deck Name (optional)' do
        custom_id 'deck_name'
        placeholder 'My Cool Deck Name'
        optional!

        value do
          registration&.deck_list&.deck_name
        end
      end

    private

      # @return [::Registration, nil]
      def registration
        return @registration if defined?(@registration)
        return @registration = nil if current_user.nil?

        @registration = @event.registrations.find_by(user: current_user)
      end

      # @return [::User, nil]
      def current_user
        return @current_user if defined?(@current_user)

        discord_id = @interaction.dig('member', 'user', 'id')
        return @current_user = nil if discord_id.nil?

        @current_user = ::User.find_by(discord_id:)
      end
    end
  end
end
