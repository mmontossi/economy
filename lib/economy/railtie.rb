module Economy
  class Railtie < Rails::Railtie

    initializer 'economy.active_record' do
      require 'economy/exchange'
      ActiveSupport.on_load :active_record do
        ::ActiveRecord::Base.include(
          Economy::Extensions::ActiveRecord::Base
        )
      end
    end

    rake_tasks do
      load 'tasks/economy.rake'
    end

  end
end
