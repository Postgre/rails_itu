require 'rails_helper'

describe 'SignUp' do
  let(:company) { companies(:itu) }
  let(:user) { users(:john) }


  context 'sign up a company' do
    context 'successfully' do

      before do


        post '/api/v1/companies',
             {company: {
                 name: 'ITU Group',
                 website: 'http://itugroup.edu/',
                 about_us: 'Lorem ipsum dolor sit amet.',
                 users_attributes: [
                     {
                         email: 'foo@bar.com',
                         password: '12345678',
                         password_confirmation: '12345678',
                         first_name: 'John',
                         last_name: 'Doe'
                     }
                 ]
             }
             }.to_json,
             {'Accept' => Mime::JSON,
              'Content-Type' => Mime::JSON.to_s}
      end

      it 'returns 201 status code' do
        expect(response.status).to eql(201)
      end
    end

    context 'unsuccessfully' do
      before do

        post '/api/v1/companies',
             {company: {
                 name: nil,
                 website: 'http://itugroup.edu/',
                 about_us: 'Lorem ipsum dolor sit amet.',
             }
             }.to_json,
             {'Accept' => Mime::JSON,
              'Content-Type' => Mime::JSON.to_s}
      end

      it 'returns 422 status code' do
        expect(response.status).to eql(422)
      end
    end
  end
end
