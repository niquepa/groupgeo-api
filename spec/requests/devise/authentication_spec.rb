require 'rails_helper'

RSpec.describe 'POST /login', type: :request do
  # let(:user) { Fabricate(:user) { after_create { |user| user.confirm } } }
  let(:user) { Fabricate(:user) }
  let(:url) { '/v1/login' }
  let(:params) do
    {
        user: {
            email: user.email,
            password: user.password
        }
    }
  end
  
  def decoded_jwt_token_from_response(response)
    token = response.headers['Authorization'].split(" ")[1]
    JWT.decode(token, Rails.application.credentials.DEVISE_JWT_SECRET_KEY, "H256")
  end

  context 'when params are correct but is not confirmed yet' do
    before do
      post url, params: params
    end

    it 'returns 401' do
      expect(response).to have_http_status(401)
      expect(response.body).to eq("You have to confirm your email address before continuing.")
    end
  end

  context 'when params are correct' do
    before do
      user.confirm
      post url, params: params
    end

    it 'returns 200' do
      expect(response).to have_http_status(200)
    end

    it 'returns JTW token in authorization header' do
      expect(response.headers['Authorization']).to be_present
    end

    it 'returns valid JWT token' do
      decoded_token = decoded_jwt_token_from_response(response)
      expect(decoded_token.first['sub']).to be_present
    end
  end

  context 'when login params are incorrect' do
    before { post url }

    it 'returns unathorized status' do
      expect(response.status).to eq 401
    end
  end
end

RSpec.describe 'DELETE /logout', type: :request do
  let(:url) { '/v1/logout' }

  it 'returns 204, no content' do
    delete url
    expect(response).to have_http_status(204)
  end
end