Economy.configure do |config|

  config.rates = :yahoo
  config.default_currency = 'USD'

  config.register_currency(
    iso_code: 'USD',
    iso_number: 840,
    symbol: 'U$S',
    decimals: 2
  )

end
