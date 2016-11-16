require 'test_helper'

class TaskTest < ActiveSupport::TestCase
  include RatesHelper

  setup do
    Dummy::Application.load_tasks
  end

  test 'update rates' do
    response = mock_response(:yahoo, '200', :multiple)
    Net::HTTP.stubs(:get_response).returns response
    silence_stream(STDOUT) do
      Rake::Task['economy:update_rates'].invoke
    end

    assert_equal 2, Economy::Exchange.count
    assert Economy::Exchange.exists?(service: 'Yahoo', from: 'USD', to: 'UYU', rate: 29.3200)
    assert Economy::Exchange.exists?(service: 'Yahoo', from: 'UYU', to: 'USD', rate: 0.0341)
  end

end
