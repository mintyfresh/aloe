# frozen_string_literal: true

module Discord
  module Commands
    # @return [Array<Module>]
    def self.all
      @all ||= constants(false)
        .map { |name| const_get(name) }
        .select { |mod| mod.try(:command?) }
        .freeze
    end

    # @param name [String]
    # @return [Module, nil]
    def self.lookup(name)
      (@lookup_index ||= all.index_by(&:command_name))[name]
    end

    # @param interaction [Hash]
    # @return [Hash]
    def self.call(interaction)
      if (command_name = interaction.dig('data', 'name')).blank?
        Rails.logger.error { "Discord command name is blank: #{interaction.inspect}" }
        return { type: Discord::INTERACTION_RESPONSE[:channel_message],
                 data: { content: 'Error. Unable to process command.' } }
      end

      if (command = lookup(command_name)).blank?
        Rails.logger.error { "Discord command not found: #{command_name.inspect}" }
        return { type: Discord::INTERACTION_RESPONSE[:channel_message],
                 data: { content: 'Error. Unable to process command.' } }
      end

      command.call(interaction)
    end
  end
end
