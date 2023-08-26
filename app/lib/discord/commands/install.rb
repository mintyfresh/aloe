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
          content = I18n.t('errors', scope: I18N_PATH, errors: guild.errors.full_messages.join(', '))
        elsif guild.previously_new_record?
          content = I18n.t('success', scope: I18N_PATH)
        else
          content = I18n.t('already_installed', scope: I18N_PATH)
        end

        respond_with_message(content:)
      end

      # @param interaction [Hash]
      # @return [Discord::Guild]
      private_class_method def self.upsert_guild_record(interaction)
        retries ||= 0

        Discord::Guild.find_or_create_by(guild_id: interaction['guild_id']) do |guild|
          guild.installed_by_id = interaction.dig('member', 'user', 'id')
          guild.name = Discord.client.guild(guild.guild_id)['name']
        end
      rescue ActiveRecord::RecordNotUnique
        retry if (retries += 1) < 3

        Discord::Guild.new.tap do |guild|
          guild.errors.add(:base, :unable_to_install)
        end
      end
    end
  end
end
