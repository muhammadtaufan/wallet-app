require 'rails_helper'

RSpec.describe Wallet, type: :model do
  let(:wallet) { create(:wallet, balance: 100) }
  let(:target_wallet) { create(:wallet, balance: 50) }

  describe '#credit' do
    it 'increases the balance by the specified amount' do
      expect { wallet.credit(50) }.to change { wallet.reload.balance }.by(50)
    end
  end

  describe '#debit' do
    context 'when the amount is less than or equal to the balance' do
      it 'decreases the balance by the specified amount' do
        expect { wallet.debit(50) }.to change { wallet.reload.balance }.by(-50)
      end
    end

    context 'when the amount is greater than the balance' do
      it 'does not decrease the balance' do
        expect { wallet.debit(150) }.not_to change(wallet, :balance)
      end
    end
  end

  describe '#topup' do
    it 'increases the balance and creates a credit transaction' do
      expect { wallet.topup(50) }.to change { wallet.reload.balance }.by(50)
                                                                     .and change {
                                                                            wallet.credit_transactions.count
                                                                          }.by(1)
    end
  end

  describe '#transfer' do
    context 'when the amount is less than or equal to the balance' do
      it 'decreases the balance, increases the target wallet balance, and creates transactions' do
        expect { wallet.transfer(target_wallet.id, 50) }.to change { wallet.reload.balance }.by(-50)
                                                                                            .and change {
                                                                                                   target_wallet.reload.balance
                                                                                                 }.by(50)
          .and change {
                 wallet.debit_transactions.count
               }.by(1)
          .and change {
                 target_wallet.credit_transactions.count
               }.by(1)
      end
    end

    context 'when the amount is greater than the balance' do
      it 'does not decrease the balance' do
        expect { wallet.transfer(target_wallet.id, 150) }.not_to change(wallet, :balance)
      end
    end
  end

  describe '#sum_balance' do
    it 'returns the correct sum balance' do
      wallet.topup(100)
      wallet.debit(25)
      expect(wallet.sum_balance.to_i).to eq(100)
    end
  end
end
