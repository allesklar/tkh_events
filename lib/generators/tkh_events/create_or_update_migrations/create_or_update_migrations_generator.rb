require 'rails/generators/migration'

module TkhEvents
  module Generators
    class CreateOrUpdateMigrationsGenerator < ::Rails::Generators::Base
      include Rails::Generators::Migration
      source_root File.expand_path('../templates', __FILE__)
      desc "create or update event migrations"
      def self.next_migration_number(path)
        unless @prev_migration_nr
          @prev_migration_nr = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i
        else
          @prev_migration_nr += 1
        end
        @prev_migration_nr.to_s
      end

      def copy_migrations
        puts 'creating or updating event migrations'
        migration_template "create_events.rb", "db/migrate/create_events.rb"
        migration_template "add_nickname_to_events.rb", "db/migrate/add_nickname_to_events.rb"
        migration_template "create_registrations.rb", "db/migrate/create_registrations.rb"
        migration_template "create_event_organizers.rb", "db/migrate/create_event_organizers.rb"
        migration_template "add_tiny_name_to_events.rb", "db/migrate/add_tiny_name_to_events.rb"
      end

    end
  end
end
