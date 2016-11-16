module Economy
  class Exchange < ActiveRecord::Base

    after_commit :cache, on: :create

    validates_presence_of :service, :from, :to, :rate
    validates_length_of :from, :to, is: 3
    validates_numericality_of :rate, greater_than: 0

    private

    def cache
      Economy.cache.set self
    end

  end
end
