Economy.configure do |config|

  config.rates = :yahoo
  config.default_currency = 'USD'

  config.add_currency(
    iso_code: 'USD',
    iso_number: 840,
    symbol: 'U$S',
    decimals: 2
  )
  config.add_currency(
    iso_code: 'UYU',
    iso_number: 858,
    symbol: '$U',
    decimals: 2
  )

end
