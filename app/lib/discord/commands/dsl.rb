# frozen_string_literal: true

module Discord
  module Commands
    module DSL
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

      # @return [Hash]
      def command_attributes
        {
          name: command_name, description:,
          dm_permission:, default_member_permissions:
        }.compact
      end
    end
  end
end
