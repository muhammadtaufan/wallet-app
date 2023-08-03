FactoryBot.define do
  factory :wallet do
    balance { 1000.0 }
    association :walletable, factory: :user
  end
end
