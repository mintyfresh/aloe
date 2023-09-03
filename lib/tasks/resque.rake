# frozen_string_literal: true

require 'resque/tasks'
require 'resque/scheduler/tasks'

task 'resque:setup' => :environment do
  Resque.logger = Rails.logger

  Resque.redis = ENV.require('REDIS_URL')
  Resque.redis.namespace = 'resque'
end

task 'resque:setup_schedule' => 'resque:setup' do
  schedule = YAML.load_file(Rails.root.join('config/schedule.yml'))
  Resque.schedule = ActiveScheduler::ResqueWrapper.wrap(schedule)
end

task 'resque:scheduler' => 'resque:setup_schedule'
