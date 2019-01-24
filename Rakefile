require 'sequel/core'
require "./boot"

namespace :generate do
  desc "Generate a timestamped, empty Sequel migration."
  task :migration, :name do |_, args|
    if args[:name].nil?
      logger.info "You must specify a migration name (e.g. rake generate:migration[create_events])!"
      exit false
    end

    content = "Sequel.migration do\n  up do\n    \n  end\n\n  down do\n    \n  end\nend\n"
    timestamp = Time.now.to_i
    filename = File.join(File.dirname(__FILE__), "db", "migrations", "#{timestamp}_#{args[:name]}.rb")

    File.open(filename, "w") do |f|
      f.puts content
    end

    logger.info "Created the migration #{filename}"
  end
end

namespace :db do
  desc "Creates db"
  task :create do
    Sequel.connect(db_template_table) do |db|
      db.execute "CREATE DATABASE #{db_name}"
    end
    logger.info "Database '#{db_name}' created"
  end

  desc "Drops db"
  task :drop do
    Sequel.connect(db_template_table) do |db|
      db.execute "DROP DATABASE #{db_name}"
    end
    logger.info "Database '#{db_name}' dropped"
  end

  desc "Recreates db"
  task :recreate do
    Sequel.connect(db_template_table) do |db|
      db.execute "DROP DATABASE IF EXISTS #{db_name}"
      db.execute "CREATE DATABASE #{db_name}"
    end
    logger.info "Database '#{db_name}' recreated"
  end

  desc "Runs database migrations"
  task :migrate do
    require "sequel/extensions/migration"
    Sequel::Migrator.run(db, "db/migrations")
    logger.info "All migrations done."
  end
end

def db_template_table
  uri = URI(ENV['DATABASE_URL'])
  uri.path = "/template1"
  uri.to_s
end

def db_name
  uri = URI(ENV['DATABASE_URL'])
  uri.path.split("/")[1].to_s
end

def logger
  Logger.new($stderr)
end

def db
  Sequel.connect(ENV.delete('DATABASE_URL'))
end
