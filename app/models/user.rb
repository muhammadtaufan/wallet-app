class User < ApplicationRecord
  include Walletable

  has_secure_password
  has_one :wallet, as: :walletable
  before_create :generate_token

  def generate_token
    loop do
      self.token = SecureRandom.hex(32)
      break unless User.where(token: token).exists?
    end
  end

  def invalid_token
    update(token: nil)
  end
end
