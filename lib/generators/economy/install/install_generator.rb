require 'rails/generators'

module Economy
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path('../templates', __FILE__)

      def add_economy_file
        copy_file 'economy.rb', 'config/initializers/economy.rb'
      end

      def add_redis_file
        copy_file 'redis.yml', 'config/redis.yml'
      end

      def add_create_exchanges_file
        migration_template 'create_exchanges.rb', 'db/migrate/create_exchanges.rb'
      end

      def self.next_migration_number(path)
        Time.now.utc.strftime '%Y%m%d%H%M%S'
      end

    end
  end
end
