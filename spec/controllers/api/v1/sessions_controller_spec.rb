require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do
  let(:user) { create(:user, password: 'password123', password_confirmation: 'password123') }

  describe 'POST #create' do
    context 'with valid credentials' do
      it 'returns a success message and token' do
        post :create, params: { email: user.email, password: 'password123' }
        json_response = JSON.parse(response.body)

        expect(response).to have_http_status(:success)
        expect(json_response['status']).to eq('success')
        expect(json_response['message']).to eq('Sign in successful')
        expect(json_response['token']).to eq(user.reload.token)
      end
    end

    context 'with invalid credentials' do
      it 'returns an error message' do
        post :create, params: { email: user.email, password: 'wrongpassword' }
        json_response = JSON.parse(response.body)

        expect(response).to have_http_status(:unauthorized)
        expect(json_response['status']).to eq('error')
        expect(json_response['message']).to eq('Invalid email or password')
      end
    end
  end

  describe 'DELETE #destroy' do
    before do
      allow(controller).to receive(:authenticate_user).and_return(true)
      allow(controller).to receive(:current_user).and_return(user)
    end

    it 'returns a success message' do
      delete :destroy
      json_response = JSON.parse(response.body)

      expect(response).to have_http_status(:success)
      expect(json_response['status']).to eq('success')
      expect(json_response['message']).to eq('Sign out successful')
    end
  end
end
