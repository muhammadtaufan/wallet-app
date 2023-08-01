module Walletable
  extend ActiveSupport::Concern

  included do
    after_create :create_wallet
  end

  private

  def create_wallet
    ActiveRecord::Base.transaction do
      Wallet.create!(walletable: self)
    end
  rescue ActiveRecord::RecordInvalid => e
    errors.add(:base, "Failed to create a wallet: #{e.message}")
    raise ActiveRecord::Rollback
  end
end
