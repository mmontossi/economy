namespace :economy do
  task update_rates: :environment do
    Economy.update_rates
  end
end
