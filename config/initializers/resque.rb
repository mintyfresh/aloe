# frozen_string_literal: true

if defined?(Resque)
  Resque.logger = Rails.logger

  Resque.redis = ENV.require('REDIS_URL')
  Resque.redis.namespace = 'resque'

  schedule = YAML.load_file(Rails.root.join('config/schedule.yml'))
  Resque.schedule = ActiveScheduler::ResqueWrapper.wrap(schedule)
end
