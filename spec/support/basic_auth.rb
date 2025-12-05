module BasicAuthHelper
  def basic_auth_header
    username = ENV["BASIC_AUTH_USER"]
    password = ENV["BASIC_AUTH_PASSWORD"]
    { HTTP_AUTHORIZATION: ActionController::HttpAuthentication::Basic.encode_credentials(username, password) }
  end
end

RSpec.configure do |config|
  config.include BasicAuthHelper, type: :request
end
