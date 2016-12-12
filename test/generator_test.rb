require 'test_helper'
require 'rails/generators'
require 'generators/economy/install/install_generator'

class GeneratorTest < Rails::Generators::TestCase
  destination Rails.root.join('tmp')

  teardown do
    FileUtils.rm_rf destination_root
  end

  test 'install' do
    self.class.tests Economy::Generators::InstallGenerator
    run_generator
    assert_file 'config/initializers/economy.rb'
    assert_file 'config/redis.yml'
    assert_migration 'db/migrate/create_exchanges.rb'
  end

end
