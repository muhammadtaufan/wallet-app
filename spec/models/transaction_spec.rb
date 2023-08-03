require 'rails_helper'

RSpec.describe Transaction, type: :model do
  let(:source_wallet) { create(:wallet, balance: 100) }
  let(:target_wallet) { create(:wallet, balance: 50) }
  let(:credit_transaction) { build(:credit_transaction, target_wallet: target_wallet, amount: 50) }
  let(:debit_transaction) { build(:debit_transaction, source_wallet: source_wallet, amount: 50) }

  describe 'validations' do
    it 'validates presence of amount' do
      credit_transaction.amount = nil
      expect(credit_transaction).not_to be_valid
    end

    it 'validates numericality of amount' do
      credit_transaction.amount = 'abc'
      expect(credit_transaction).not_to be_valid
    end

    it 'validates presence of target_wallet for credit transactions' do
      credit_transaction.target_wallet = nil
      expect(credit_transaction).not_to be_valid
    end

    it 'validates presence of source_wallet for debit transactions' do
      debit_transaction.source_wallet = nil
      expect(debit_transaction).not_to be_valid
    end
  end
end
