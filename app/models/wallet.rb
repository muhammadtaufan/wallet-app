class Wallet < ApplicationRecord
  belongs_to :walletable, polymorphic: true

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
end
