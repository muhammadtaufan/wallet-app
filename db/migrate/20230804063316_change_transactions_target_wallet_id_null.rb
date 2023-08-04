class ChangeTransactionsTargetWalletIdNull < ActiveRecord::Migration[6.0]
  def change
    change_column_null :transactions, :target_wallet_id, true
  end
end
