require 'rspec/core/rake_task'
require 'dotenv/tasks'
require 'active_record'

RSpec::Core::RakeTask.new(:spec) do |task|
  task.rspec_opts = '--color'
  task.verbose    = false
end

namespace :db do
  desc 'Migrate the database (options: VERSION=x, VERBOSE=false).'
  task migrate: :configure_connection do
    ActiveRecord::Migration.verbose = true
    ActiveRecord::Migrator.migrate 'db/migrate', ENV['VERSION'] ? ENV['VERSION'].to_i : nil
  end

  task rollback: :configure_connection do
    step = ENV['STEP'] ? ENV['STEP'].to_i : 1
    ActiveRecord::Migrator.rollback 'db/migrate', step
  end

  task configure_connection: :dotenv do
    ActiveRecord::Base.establish_connection ENV['DATABASE_URL']
  end
end
