# frozen_string_literal: true

Discord.client.create_global_command(
  name:        'install',
  description: 'Install Aloe, the MLPCCG Discord bot into this server. ' \
               'Only available to server administrators.',
  # Restrict command to administrator, disable in DMs.
  dm_permission: false, default_member_permissions: '1000'
)
