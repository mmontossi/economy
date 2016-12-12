module RateHelper
  extend ActiveSupport::Concern

  private

  def mock_response(service, code, name)
    response = mock
    response.expects(:code).returns code
    if name
      body = File.read(File.dirname(__FILE__) + "/../fixtures/#{service}/#{name}.json")
      response.expects(:body).returns body
    end
    response
  end

end
