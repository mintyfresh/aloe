# frozen_string_literal: true

module Discord
  module Commands
    module Install
      extend DSL

      I18N_PATH = 'discord.commands.install'

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
        guild = upsert_guild_record(interaction)

        if guild.errors.any?
          content = I18n.t('failure', scope: I18N_PATH, errors: guild.errors.full_messages.join(', '))
        elsif guild.previously_new_record?
          content = I18n.t('created', scope: I18N_PATH)
        else
          content = I18n.t('updated', scope: I18N_PATH)
        end

        respond_with_message(content:)
      end

      # @param interaction [Hash]
      # @return [Discord::Guild]
      private_class_method def self.upsert_guild_record(interaction)
        retries ||= 0

        guild = Discord::Guild.find_or_initialize_by(guild_id: interaction['guild_id'])
        guild.installed_by_id ||= interaction.dig('member', 'user', 'id')
        guild.event_channel_id  = interaction.dig('channel', 'id')

        guild.tap(&:save!)
      rescue ActiveRecord::RecordNotUnique
        retry if (retries += 1) < 3

        Discord::Guild.build_with_error(:base, :unable_to_install)
      end
    end
  end
end
