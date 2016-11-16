require 'test_helper'

class MoneyTest < ActiveSupport::TestCase
  include MoneyHelper

  test 'abs and magnitude' do
    %i(abs magnitude).each do |method|
      assert_equal 10, money(-10, 'USD').send(method).amount
      assert_equal 10, money(10, 'USD').send(method).amount
    end
  end

  test '-@' do
    assert_equal -10, (-money(10, 'USD')).amount
    assert_equal 10, (-money(-10, 'USD')).amount
  end

  test 'positive?' do
    assert money(10, 'USD').positive?
    assert_not money(-10, 'USD').positive?
    assert_not money(0, 'USD').positive?
  end

  test 'negative?' do
    assert money(-10, 'USD').negative?
    assert_not money(10, 'USD').negative?
    assert_not money(0, 'USD').negative?
  end

  test 'zero?' do
    assert money(0, 'USD').zero?
    assert_not money(4, 'USD').zero?
  end

  test 'nonzero?' do
    assert money(4, 'USD').nonzero?
    assert_not money(0, 'USD').nonzero?
  end

  test '<' do
    assert_operator money(2, 'USD'), :<, money(4, 'USD')
    assert_not_operator money(2, 'USD'), :<, money(2, 'USD')
    assert_not_operator money(2, 'USD'), :<, money(10, 'UYU')
    assert_raises do
      money(10, 'USD') < 4
    end
  end

  test '===' do
    assert_operator money(10, 'USD'), :===, money(10, 'USD')
    assert_not_operator money(10, 'USD'), :===, money(10, 'UYU')
    assert_raises do
      money(10, 'USD') === 10
    end
  end

  test '<=>' do
    assert_equal -1, (money(5, 'USD') <=> money(10, 'USD'))
    assert_equal 0, (money(10, 'USD') <=> money(10, 'USD'))
    assert_equal 1, (money(10, 'USD') <=> money(5, 'UYU'))
    assert_raises do
      money(10, 'USD') <=> 4
    end
  end

  test '+' do
    assert_equal 17, (money(10, 'USD') + money(7, 'USD')).amount
    assert_equal 20, (money(5, 'USD') + money(300, 'UYU')).amount
    assert_raises do
      money(10, 'USD') + 4
    end
  end

  test '-' do
    assert_equal 3, (money(10, 'USD') - money(7, 'USD')).amount
    assert_equal 5, (money(10, 'USD') - money(100, 'UYU')).amount
    assert_raises do
      money(10, 'USD') - 5
    end
  end

  test '*' do
    assert_equal 30, (money(10, 'USD') * 3).amount
    assert_raises do
      money(10, 'USD') * money(3, 'USD')
    end
  end

  test '/ and div' do
    %i(/ div).each do |operator|
      assert_equal 5, (money(10, 'USD').send(operator, 2)).amount
      assert_equal 5, (money(10, 'USD').send(operator, money(40, 'UYU')))
      assert_raises do
        money(10, 'USD').send operator, 'a'
      end
    end
  end

  test 'divmod' do
    assert_equal [money(3, 'USD'), money(1, 'USD')], money(13, 'USD').divmod(4)
    assert_equal [3, money(1, 'USD')], money(13, 'USD').divmod(money(80, 'UYU'))
    assert_raises do
      money(10, 'USD').divmod 'a'
    end
  end

  test '% and modulo' do
    %i(% modulo).each do |operator|
      assert_equal money(1, 'USD'), money(13, 'USD').send(operator, 4)
      assert_equal money(1, 'USD'), money(13, 'USD').send(operator, money(80, 'UYU'))
      assert_raises do
        money(10, 'USD').divmod 'a'
      end
    end
  end

  test 'remainder' do
    assert_equal money(1, 'USD'), money(13, 'USD').remainder(4)
    assert_equal money(1, 'USD'), money(13, 'USD').remainder(money(80, 'UYU'))
  end

  test 'exchange_to' do
    assert_raises do
      money(10, 'USD').exchange_to 'EUR'
    end
  end

  test 'to_json and as_json' do
    %i(to_json as_json).each do |method|
      assert_equal '10.70', money(10.7, 'USD').send(method)
    end
  end

  test 'to_s' do
    assert_equal 'U$S122,444.46', money(122444.45544, 'USD').to_s
  end

end
