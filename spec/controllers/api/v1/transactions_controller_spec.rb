require 'rails_helper'

RSpec.describe Api::V1::TransactionsController, type: :controller do
  let(:user) { create(:user) }
  let(:wallet) { create(:wallet, walletable: user) }
  let(:target_wallet) { create(:wallet) }

  before do
    allow(controller).to receive(:authenticate_user).and_return(true)
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'POST #transfer' do
    subject { post :transfer, params: { wallet_id: wallet.id, target_wallet_id: target_wallet.id, amount: amount } }

    context 'when the transfer is successful' do
      let(:amount) { 50 }

      it 'returns a success message' do
        subject
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['status']).to eq('success')
      end
    end

    context 'when the transfer fails' do
      let(:amount) { 5000 }

      it 'returns an error message' do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['status']).to eq('error')
      end
    end
  end

  describe 'POST #withdraw' do
    subject { post :withdraw, params: { wallet_id: wallet.id, amount: amount } }

    context 'when the withdrawal is successful' do
      let(:amount) { 50 }

      it 'returns a success message' do
        subject
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['status']).to eq('success')
      end
    end

    context 'when the withdrawal fails' do
      let(:amount) { 5000 }

      it 'returns an error message' do
        subject

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['status']).to eq('error')
      end
    end
  end

  describe 'POST #topup' do
    subject { post :topup, params: { wallet_id: wallet.id, amount: amount } }

    context 'when the topup is successful' do
      let(:amount) { 50 }

      it 'returns a success message' do
        subject
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['status']).to eq('success')
      end
    end

    context 'when the topup fails' do
      let(:amount) { -50 }

      it 'returns an error message' do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['status']).to eq('error')
      end
    end
  end

  describe 'GET #balance' do
    subject { get :balance, params: { wallet_id: wallet.id } }

    it 'returns the balance' do
      subject
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['status']).to eq('success')
    end
  end
end
