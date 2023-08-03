FactoryBot.define do
  factory :transaction do
    amount { 100.0 }
    association :source_wallet, factory: :wallet
    association :target_wallet, factory: :wallet
    type { 'CreditTransaction' }
  end
end

FactoryBot.define do
  factory :credit_transaction, class: 'CreditTransaction' do
    amount { 50 }
    association :target_wallet, factory: :wallet
  end

  factory :debit_transaction, class: 'DebitTransaction' do
    amount { 50 }
    association :source_wallet, factory: :wallet
  end
end
