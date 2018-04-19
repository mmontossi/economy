require 'rails/generators'

module Economy
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path('../templates', __FILE__)

      def add_initializer
        copy_file 'economy.rb', 'config/initializers/economy.rb'
      end

      def add_migrations
        migration_template 'create_currencies.rb', 'db/migrate/create_currencies.rb'
        migration_template 'create_exchanges.rb', 'db/migrate/create_exchanges.rb'
      end

      def self.next_migration_number(path)
        Time.now.utc.strftime '%Y%m%d%H%M%S'
      end

    end
  end
end
