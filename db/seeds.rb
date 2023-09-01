# frozen_string_literal: true

Discord::Commands::Install.install

Organization.find_or_create_by!(name: 'Commentary is Magic')
