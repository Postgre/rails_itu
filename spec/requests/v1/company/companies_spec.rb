require 'rails_helper'

describe 'Company' do
  let(:company)       { FactoryGirl.create :company, :itu }
  let(:user)          { User.find company.users.where(first_name: 'John').first.id }
  let(:wrong_user)    { create :user }

  context 'with wrong user' do
    context 'update an existing Company' do
      context 'unsuccessfully' do
        before do
          login_as(wrong_user, :scope => :user)
          patch "/api/v1/companies/#{company.id}", { company: { name: 'NEW ITU' } }.to_json, json_content_type
        end

        it 'returns 403 status code' do
          expect(response.status).to eql(403)
        end
      end
    end
  end

  context 'without logged user' do
    # context 'show Company' do
    #   before do
    #     get "/api/v1/companies/#{company.id}", {},
    #       {
    #         'Accept' => Mime::JSON,
    #         'Content-Type' => Mime::JSON.to_s
    #       }
    #   end
    #
    #   it 'returns success' do
    #     expect(response).to be_success
    #   end
    #
    #   it 'returns content_type as JSON' do
    #     expect(response.content_type).to eql(Mime::JSON)
    #   end
    #
    #   it 'returns JSON with company data' do
    #     c = json(response.body)
    #     expect(c[:name]).to eql('ITU')
    #   end
    # end

    context 'create a Company' do
      context 'successfully' do
        before do
          post '/api/v1/companies/',
            { company: {
                name: 'ITU Group',
                website: 'http://itugroup.edu/',
                about_us: 'Lorem ipsum dolor sit amet.',
                users_attributes: [{
                  email: 'jdoe@itugroup.edu',
                  password: '123456',
                  password_confirmation: '123456',
                  prefix: 'Sr.',
                  first_name: 'John',
                  middle_name: '',
                  last_name: 'Doe',
                  address: '2345 here and there',
                  city: 'San Jose',
                  country: 'US',
                  state: 'CA',
                  time_zone: Time.zone.name,
                  phone_number: '404-414-2345'
                }]
              }
            }.to_json,
            {
              'Accept' => Mime::JSON,
              'Content-Type' => Mime::JSON.to_s
            }
        end

        it 'returns 201 status code' do
          expect(response.status).to eql(201)
        end

        it 'returns content_type as JSON' do
          expect(response.content_type).to eql(Mime::JSON)
        end

        it 'returns JSON with company data' do
          company = json(response.body)[:company]
          expect(company[:name]).to eql('ITU Group')
        end
      end

      context 'unsuccessfully' do
        before do
          post '/api/v1/companies/',
            { company: {
                name: nil,
                website: 'http://itugroup.edu/',
                about_us: 'Lorem ipsum dolor sit amet.',
                skype_username: 'itugroup',
                users_attributes: [{
                  email: 'jdoe@itugroup.edu',
                  password: '123456',
                  password_confirmation: '123456',
                  prefix: 'Sr.',
                  first_name: 'John',
                  middle_name: '',
                  last_name: 'Doe'
                }]
              }
            }.to_json,
            { 'Accept' => Mime::JSON,
              'Content-Type' => Mime::JSON.to_s }
        end

        it 'returns 422 status code' do
          expect(response.status).to eql(422)
        end

        it 'returns content_type as JSON' do
          expect(response.content_type).to eql(Mime::JSON)
        end

        it 'returns JSON with error data' do
          name_errors = json(response.body)[:errors][:name]
          expect(name_errors).to eql(["can't be blank", "is too short (minimum is 3 characters)"])
        end
      end
    end
  end

  context 'with logged user' do
    context 'update an existing Company' do
      context 'successfully' do
        before do
          login_as(user, :scope => :user)
          patch "/api/v1/companies/#{company.id}", { company: { name: 'NEW ITU' } }.to_json,
                json_content_type
        end

        it 'returns 200 status code' do
          expect(response.status).to eql(200)
        end

        it 'returns content_type as JSON' do
          expect(response.content_type).to eql(Mime::JSON)
        end

        it 'updates existing company name' do
          response_body = json(response.body)
          expect(response_body[:name]).to eql('NEW ITU')
        end
      end

      context 'unsuccessfully' do
        before do
          login_as(user, :scope => :user)
          patch "api/v1/companies/#{company.id}",
            { company: { name: nil } }.to_json, json_content_type
        end

        after { Timecop.return }

        it 'returns 422 status code' do
          expect(response.status).to eql(422)
        end

        it 'returns content_type as JSON' do
          expect(response.content_type).to eql(Mime::JSON)
        end

        it 'returns JSON with error data' do
          response_body = json(response.body)
          expect(response_body[:name]).to eql(["can't be blank", "is too short (minimum is 3 characters)"])
        end
      end
    end
  end

  context 'company representatives manage' do
    context 'add' do
      context 'unsuccessfully' do
        before do
          login_as(user, :scope => :user)
          put "/api/v1/companies/#{company.id}/invite",
              { representative: { email: 'fake_address_100@itu.edu' } }.to_json,
              json_content_type
        end

        it 'returns 422 status code' do
          expect(response.status).to eql(422)
        end
      end

      context 'add new user to a system' do
        before do
          login_as(user, :scope => :user)
          put "/api/v1/companies/#{company.id}/invite",
              { representative: {
                  email: 'fake_address_100@itu.edu',
                  first_name: 'Johny',
                  last_name: 'Bravo',
                  password: 'qwerty1234',
                  password_confirmation: 'qwerty1234'
              } }.to_json,
              json_content_type
        end

        it 'returns success' do
          expect(response).to be_success
        end

        it 'have new user in reps' do
          response_body = json(response.body)
          expect(response_body[:users].size).to eql(2)
          expect(response_body[:users].select{|e| e[:email] == 'fake_address_100@itu.edu'}.size).to eql(1)
        end
      end

      context 'successfully' do
        before do
          login_as(user, :scope => :user)
          put "/api/v1/companies/#{company.id}/invite",
              { representative: { email: wrong_user.email } }.to_json,
              json_content_type
        end

        it 'returns success' do
          expect(response).to be_success
        end

        it 'have new user in reps' do
          response_body = json(response.body)
          expect(response_body[:users].size).to eql(2)
          expect(response_body[:users].select{|e| e[:email] == wrong_user.email}.size).to eql(1)
        end
      end

      context "can't add user twice" do
        before do
          login_as(user, :scope => :user)
          put "/api/v1/companies/#{company.id}/invite",
              { representative: { email: wrong_user.email } }.to_json,
              json_content_type
          put "/api/v1/companies/#{company.id}/invite",
              { representative: { email: wrong_user.email } }.to_json,
              json_content_type
        end

        it 'returns 422 status code' do
          expect(response.status).to eql(422)
        end

        it 'return valid error message' do
          errors = json(response.body)[:errors]
          expect(errors).to eql([I18n.t('roles.company.representative.cant_add_already_existing_rep')])
        end
      end
    end

    context 'remove' do
      context 'successfully' do
        before do
          login_as(user, :scope => :user)
          put "/api/v1/companies/#{company.id}/invite",
              { representative: { email: wrong_user.email } }.to_json,
              json_content_type
          delete "/api/v1/companies/#{company.id}/expel",
              { representative: { email: wrong_user.email } }.to_json,
              json_content_type
        end

        it 'returns success' do
          expect(response).to be_success
        end

        it 'not have new user in reps' do
          response_body = json(response.body)
          expect(response_body[:users].size).to eql(1)
          expect(response_body[:users].select{|e| e[:email] == wrong_user.email}.size).to eql(0)
        end
      end

      context 'unsuccessfully' do
        before do
          login_as(user, :scope => :user)
          delete "/api/v1/companies/#{company.id}/expel",
              { representative: { email: wrong_user.email } }.to_json,
              json_content_type
        end

        it 'returns 422 status code' do
          expect(response.status).to eql(422)
        end

        it 'return valid error message' do
          errors = json(response.body)[:errors]
          expect(errors).to eql([I18n.t('roles.company.representative.cant_remove_non_existing')])
        end
      end

      context "can't remove himself" do
        before do
          login_as(user, :scope => :user)
          delete "/api/v1/companies/#{company.id}/expel",
              { representative: { email: user.email } }.to_json,
              json_content_type
        end

        it 'returns 422 status code' do
          expect(response.status).to eql(422)
        end

        it 'return valid error message' do
          errors = json(response.body)[:errors]
          expect(errors).to eql([I18n.t('roles.company.representative.cant_remove_yourself')])
        end
      end
    end
  end
end
