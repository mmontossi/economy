namespace :economy do

  desc 'Updates all rates.'
  task update_rates: :environment do
    Economy.update_rates
  end

end
