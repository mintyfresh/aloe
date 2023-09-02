# frozen_string_literal: true

module Discord
  module Commands
    module DSL
      # @param base [Module]
      # @return [void]
      def self.extended(base)
        super(base).tap do
          base.define_singleton_method(:command?) { true }
        end
      end

      # @return [Boolean]
      def command?
        false
      end

      # @overload command_name()
      #   @return [String, nil]
      # @overload command_name(name)
      #   @param name [String]
      #   @return [void]
      def command_name(name = nil)
        if name.nil?
          @command_name
        else
          @command_name = name
        end
      end

      # @overload description()
      #   @return [String, nil]
      # @overload description(description)
      #   @param description [String]
      #   @return [void]
      def description(description = nil)
        if description.nil?
          @description
        else
          @description = description
        end
      end

      # @overload dm_permission()
      #   @return [Boolean, nil]
      # @overload dm_permission(dm_permission)
      #   @param dm_permission [Boolean]
      #   @return [void]
      def dm_permission(dm_permission = nil)
        if dm_permission.nil?
          @dm_permission
        else
          @dm_permission = dm_permission
        end
      end

      # @overload default_member_permissions()
      #   @return [String, nil]
      # @overload default_member_permissions(default_member_permissions)
      #   @param default_member_permissions [String]
      #   @return [void]
      def default_member_permissions(default_member_permissions = nil)
        if default_member_permissions.nil?
          @default_member_permissions
        else
          @default_member_permissions = default_member_permissions
        end
      end

      # @return [Array<Hash>]
      def options
        @options ||= []
      end

      # @param name [String, Symbol]
      # @param description [String, nil]
      # @param attributes [Hash]
      # @return [void]
      def option(name, description = nil, **)
        options << { type: 3, description:, **, name: name.to_s }
      end

      # @return [Hash]
      def command_attributes
        {
          name: command_name, description:, options: options.presence,
          dm_permission:, default_member_permissions:
        }.compact
      end

      # @return [Array<String>]
      def i18n_path
        @i18n_path ||= name.underscore.tr('/', '.').freeze
      end

    protected

      # @param key [String, Symbol]
      def translate(key, **)
        if key.to_s.start_with?('.')
          I18n.t(key, scope: i18n_path, **)
        else
          I18n.t(key, **)
        end
      end

      alias t translate

      # @param data [Hash]
      # @return [Hash]
      def respond_with_message(**data)
        { type: Discord::INTERACTION_RESPONSE[:channel_message], data: }
      end
    end
  end
end
