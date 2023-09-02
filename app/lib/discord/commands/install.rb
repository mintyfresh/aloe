# frozen_string_literal: true

module Discord
  module Commands
    module Install
      extend DSL

      command_name 'install'

      description 'Install Aloe, the MLPCCG Discord bot into this server. ' \
                  'Only available to server administrators.'

      dm_permission false
      default_member_permissions '1000'

      option :token, 'Organization install token', required: true, min_length: 32, max_length: 32

      # @return [void]
      def self.install
        Discord.client.create_global_command(**command_attributes)
      end

      # @param interaction [Hash]
      # @return [Hash]
      def self.call(interaction)
        token = extract_token(interaction)

        if (organization = ::Organization.find_by_install_token(token)).nil?
          return respond_with_message(content: t('.invalid_token'))
        end

        if organization.update(discord_guild_id: interaction['guild_id'])
          # rotate the token after successful install
          # to prevent it from being reused elsewhere by accident
          organization.regenerate_install_token

          content = t('.success')
        else
          content = t('.failure', errors: organization.errors.full_messages.join(', '))
        end

        respond_with_message(content:)
      end

      # @param interaction [Hash]
      # @return [String, nil]
      private_class_method def self.extract_token(interaction)
        interaction.dig('data', 'options')&.find { |option| option['name'] == 'token' }&.dig('value')
      end
    end
  end
end
