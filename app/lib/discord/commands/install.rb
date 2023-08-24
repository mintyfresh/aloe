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

      # @return [void]
      def self.install
        Discord.client.create_global_command(command_attributes)
      end

      # @param interaction [Hash]
      # @return [Hash]
      def self.call(interaction)
        guild_id = interaction['guild_id']

        Rails.logger.debug { "Guild ID: #{guild_id}" }
        Rails.logger.debug { Discord.client.guild(guild_id) }

        {
          type: Discord::INTERACTION_RESPONSE[:channel_message],
          data: { content: 'Successfully installed' }
        }
      end
    end
  end
end
