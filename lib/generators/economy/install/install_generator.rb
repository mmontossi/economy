require 'rails/generators'

module Economy
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path('../templates', __FILE__)

      def create_initializer_file
        copy_file 'initializer.rb', 'config/initializers/economy.rb'
      end

      def create_configuration_file
        copy_file 'configuration.yml', 'config/redis.yml'
      end

      def create_migration_file
        migration_template 'migration.rb', 'db/migrate/create_exchanges.rb'
      end

      def self.next_migration_number(path)
        Time.now.utc.strftime '%Y%m%d%H%M%S'
      end

    end
  end
end
