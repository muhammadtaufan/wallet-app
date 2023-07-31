class Stock < ApplicationRecord
  has_one :wallet, as: :walletable
end
