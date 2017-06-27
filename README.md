[![Gem Version](https://badge.fury.io/rb/economy.svg)](http://badge.fury.io/rb/economy)
[![Code Climate](https://codeclimate.com/github/mmontossi/economy/badges/gpa.svg)](https://codeclimate.com/github/mmontossi/economy)
[![Build Status](https://travis-ci.org/mmontossi/economy.svg)](https://travis-ci.org/mmontossi/economy)
[![Dependency Status](https://gemnasium.com/mmontossi/economy.svg)](https://gemnasium.com/mmontossi/economy)

# Economy

High performance multicurrency money for rails.

## Why

I did this gem to:

- Keep rates cached in redis for optimal performance and sync between instances.
- Have an out of the box working rates service.
- Be able to make sql queries without the need to convert integers into decimals.
- Share a common currency column for multiple money fields if a need it.
- Avoid the need to manually format the string representation in views.

## Install

Put this line in your Gemfile:
```ruby
gem 'economy'
```

Then bundle:
```
$ bundle
```

To install Redis you can use homebrew:
```
$ brew install redis
```

## Configuration

Generate the configuration file:
```
$ bundle exec rails g economy:install
```

Set the global settings:
```ruby
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
```

NOTE: You may want to personalize the generated config/redis.yml.

## Usage

### Definitions

Define the money field in your models:
```ruby
class Product < ActiveRecord::Base
  monetize :price
end
```

Add the money columns to your tables:
```ruby
class AddPriceToProducts < ActiveRecord::Migration
  def change
    add_column :products, :price, :decimal, precision: 24, scale: 6
    add_column :products, :currency, :string
  end
end
```

NOTE: You can use a gobal "currency" column o a prefixed "price_currency" column.

### Attributes

If you want to assign values, everything continuos working the same:
```ruby
product.price = 20.00
product.currency = 'USD'
```

Arithmetics are intuitive:
```ruby
product.price * 2
# => U$S 40

product.price / 2
# => U$S 10

product.price + Economy::Money.new(10, 'USD')
# => U$S 30

product.price - Economy::Money.new(10, 'USD')
# => U$S 10
```

To exchange to another currency:
```ruby
product.price.exchange_to 'UYU'
```

The formatting method is to_s, it uses active support, so there is no need to call a helper in your views:
```erb
<%= product.price %>
```

### Rates

To update rates:
```
$ bundle exec rake economy:update_rates
```

Or the plain method:
```ruby
Economy.update_rates
```

NOTE: You probably want to put the rake task into a cronjob.

## Contributing

Any issue, pull request, comment of any kind is more than welcome!

I will mainly ensure compatibility to Rails, AWS, PostgreSQL, Redis, Elasticsearch and FreeBSD. 

## Credits

This gem is maintained and funded by [mmontossi](https://github.com/mmontossi).

## License

It is free software, and may be redistributed under the terms specified in the MIT-LICENSE file.
