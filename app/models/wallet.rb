class Wallet < ApplicationRecord
  belongs_to :walletable, polymorphic: true
  has_many :credit_transactions, class_name: 'CreditTransaction', foreign_key: 'target_wallet_id'
  has_many :debit_transactions, class_name: 'DebitTransaction', foreign_key: 'source_wallet_id'

  def credit(amount)
    # do the pesimistic locking instead
    with_lock do
      self.balance += amount
      save!
    end
  end

  def debit(amount)
    # do the pesimistic locking instead
    with_lock do
      raise ActiveRecord::Rollback unless balance >= amount

      self.balance -= amount
      save!
    end
  end

  def topup(amount)
    with_lock do
      ActiveRecord::Base.transaction do
        credit_transactions.create!(amount: amount, source_wallet: self)
      end
    rescue ActiveRecord::RecordInvalid => e
      errors.add(:base, "Failed to topup: #{e.message}")
      raise ActiveRecord::Rollback
    end
  end
end
