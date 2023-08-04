class Transaction < ApplicationRecord
  belongs_to :source_wallet, class_name: 'Wallet', optional: true
  belongs_to :target_wallet, class_name: 'Wallet', optional: true

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validate :wallets_presence

  after_create :execute
  before_save :check_balance

  private

  def execute
    case type
    when 'CreditTransaction'
      target_wallet.credit(amount)
    when 'DebitTransaction'
      source_wallet.debit(amount)
    end
  end

  def wallets_presence
    if type == 'CreditTransaction' && target_wallet.blank?
      errors.add(:target_wallet, "can't be blank for credit transactions")
    elsif type == 'DebitTransaction' && source_wallet.blank?
      errors.add(:source_wallet, "can't be blank for debit transactions")
    end
  end

  def check_balance
    if type == 'DebitTransaction' && source_wallet.balance < amount
      errors.add(:base, 'Insufficient balance')
      throw :abort
    end
  end
end
