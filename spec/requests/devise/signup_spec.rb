require 'rails_helper'

RSpec.describe 'POST /signup', type: :request do
  let(:url) { '/v1/signup' }
  let(:params) do
    {
        user: {
            email: 'user@example.com',
            password: 'password'
        }
    }
  end

  context 'when user is unauthenticated' do
    before { post url, params: params }

    it 'returns 200' do
      expect(response.status).to eq 200
    end

    it 'returns a new user' do
      expect(response.body).to match_response_schema('user')
    end
  end

  context 'when user already exists' do
    before do
      Fabricate :user, email: params[:user][:email]
      post url, params: params
    end

    it 'returns bad request status' do
      expect(response.status).to eq 400
    end

    it 'returns validation errors' do
      parsed_body = JSON.parse(response.body)
      error_title = parsed_body['errors'].first['title']
      error_email = parsed_body['errors'].first['detail']['email'].first
      expect(error_title).to eq('Bad Request')
      expect(error_email).to eq('has already been taken')
    end
  end
end