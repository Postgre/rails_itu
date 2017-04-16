require 'rails_helper'
#TODO include tests for other rescue methods
#FIXME: https://relishapp.com/rspec/rspec-rails/docs/routing-specs/be-routable-matcher
# describe 'ApplicationController' do
#
#   let(:user) {users(:john)}
#   subject {create(:skill_category)}
#
#   context 'unrecognised path with a valid access_token' do
#     before do
#       Rails::Redis.hset(user.access_token, 'itu_id', user.itu_id)
#       get "/api/v1/something", {}, json_content_type(user.access_token)
#     end
#
#     it 'returns a 404' do
#       expect(response.status).to eq(404)
#     end
#   end
#
#   context 'unrecognised path without a invalid access_token' do
#     before do
#       get "/api/v1/something", {}, json_content_type
#     end
#
#     it 'returns a 401' do
#       expect(response.status).to eq(401)
#     end
#   end
# end
