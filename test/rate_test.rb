require 'test_helper'

class RateTest < ActiveSupport::TestCase
  include RateHelper

  test 'retries' do
    base = Economy::Rates::Base.new
    base.expects(:call).raises('Error').times(31)
    base.expects(:sleep).with(60).times(30)
    silence_stream(STDOUT) do
      base.fetch
    end
  end

  test 'yahoo' do
    ids = Economy.currencies.map(&:iso_code).permutation(2).map(&:join).join(',')
    uri = URI('https://query.yahooapis.com/v1/public/yql')
    uri.query = URI.encode_www_form(
      q: "select * from yahoo.finance.xchange where pair in ('#{ids}')",
      env: 'store://datatables.org/alltableswithkeys',
      format: 'json'
    )
    assert_response(
      :yahoo,
      uri,
      [['USD','UYU',29.3200]],
      '200',
      :single
    )
    assert_response(
      :yahoo,
      uri,
      [['USD','UYU',29.3200],['UYU','USD',0.0341]],
      '200',
      :multiple
    )
    assert_response(
      :yahoo,
      uri,
      [],
      '200',
      :unknown
    )
    assert_response(
      :yahoo,
      uri,
      [],
      '500'
    )
  end

  private

  def assert_response(service, uri, result, code, name=nil)
    response = mock_response(service, code, name)
    Net::HTTP.stubs(:get_response).with(uri).returns response
    assert_equal result, Economy::Rates::Yahoo.new.fetch
  end

end
