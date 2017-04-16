module Helpers
  def json(body)
    JSON.parse(body, symbolize_names: true)
  end

  def token_header(token)
    ActionController::HttpAuthentication::Token.encode_credentials(token)
  end

  def json_content_type(access_token=nil)
     {
       'Accept' => Mime::JSON,
       'Content-Type' => Mime::JSON.to_s,
       'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Token.encode_credentials(access_token)
     }
  end
end
