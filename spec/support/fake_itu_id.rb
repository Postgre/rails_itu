require 'sinatra/base'
require 'factory_girl'
Dir[File.dirname(__FILE__)+"/factories/*.rb"].each {|file| require file }

class FakeItuId < Sinatra::Base
  get '/api/v1/users/:id' do
    json_response 200, 'user.json', params[:id].gsub('.json', '')
  end

  post '/api/v1/users.json' do
    json_response 201, 'user.json', Rails::Redis.incr(:user_id)
  end

  private

    def json_response(response_code, file_name, id)
      content_type :json
      status response_code

      File.open(File.dirname(__FILE__) + '/fixtures/' + file_name, 'rb').read.gsub('0', id.to_s).gsub('TOKEN', SecureRandom.hex)
    end
end