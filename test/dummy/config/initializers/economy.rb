Economy.configure do |config|

  config.redis = Redis.new(url: 'redis://localhost:6379/0')
  config.rates = :yahoo
  config.default_currency = 'USD'

  config.register_currency(
    iso_code: 'USD',
    iso_number: 840,
    symbol: 'U$S',
    decimals: 2
  )
  config.register_currency(
    iso_code: 'UYU',
    iso_number: 858,
    symbol: '$U',
    decimals: 2
  )

end
