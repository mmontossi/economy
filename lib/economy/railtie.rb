module Economy
  class Railtie < Rails::Railtie

    initializer 'economy.extensions' do
      # Prevent deprecation warning
      require 'economy/exchange'

      ::ActiveRecord::Base.include(
        Economy::Extensions::ActiveRecord::Base
      )
    end

    rake_tasks do
      load 'tasks/economy.rake'
    end

  end
end
