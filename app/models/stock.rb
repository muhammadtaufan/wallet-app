class Stock < ApplicationRecord
  include Walletable
  has_one :wallet, as: :walletable
end
