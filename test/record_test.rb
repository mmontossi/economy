require 'test_helper'

class RecordTest < ActiveSupport::TestCase
  include MoneyHelper

  test 'default currency' do
    product = Product.new
    assert_equal 0, product.price
    assert_equal 'USD', product.price.currency.iso_code
    assert_nil product.price_currency
  end

  test 'persistent' do
    plan = Plan.create(monthly_price: 20, annually_price: 200, currency: 'UYU')
    assert_equal 20, plan.monthly_price.amount
    assert_equal 'UYU', plan.monthly_price.currency.iso_code
    assert_equal 200, plan.annually_price.amount
    assert_equal 'UYU', plan.annually_price.currency.iso_code
    assert_equal 'UYU', plan.currency

    plan.update monthly_price: money(5, 'USD')
    assert_equal 100, plan.monthly_price.amount
    assert_equal 200, plan.annually_price.amount
    assert_equal 'UYU', plan.currency

    product = Product.create(price: 15, price_currency: 'UYU')
    assert_equal 15, product.price.amount
    assert_equal 'UYU', product.price.currency.iso_code
    assert_equal 'UYU', product.price_currency

    product.update price: money(5, 'USD')
    assert_equal 5, product.price.amount
    assert_equal 'USD', product.price.currency.iso_code
    assert_equal 'USD', product.price_currency
  end

  test 'validators' do
    product = Product.new
    assert product.valid?

    product.price = 20
    assert product.invalid?

    product.price_currency = 'IO'
    assert product.invalid?

    product.price_currency = 'UYU'
    assert product.valid?

    product.price = 0
    assert product.valid?
  end

  test 'helpers' do
    product = Product.new(price: 10000)
    assert product.price_came_from_user?
    assert_equal '10000.00', product.price_before_type_cast
  end

end
