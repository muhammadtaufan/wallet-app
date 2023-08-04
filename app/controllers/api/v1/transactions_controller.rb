class Api::V1::TransactionsController < Api::V1::ApplicationController
  before_action :set_wallet

  def transfer
    if @wallet.transfer(params[:target_wallet_id], params[:amount])
      render json: { status: 'success', message: 'Transfer successful' }, status: :created
    else
      render json: { status: 'error', message: @wallet.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def withdraw
    @transaction = @wallet.debit_transactions.build(transaction_params.merge(type: 'DebitTransaction'))
    if @transaction.save
      render json: { status: 'success', data: @transaction, message: 'Transfer successful' }, status: :created
    else
      render json: { status: 'error', message: @transaction.errors.full_messages.join(', ') },
             status: :unprocessable_entity
    end
  end

  def topup
    amount = params[:amount].to_f

    if @wallet.topup(amount)
      render json: { status: 'success', message: 'Topup successful' }
    else
      render json: { status: 'error', message: 'Topup failed' }, status: :unprocessable_entity
    end
  end

  def balance
    render json: { status: 'success', data: { balance: @wallet.sum_balance } }, status: :ok
  end

  private

  def set_wallet
    @wallet = Wallet.find(params[:wallet_id])
  end

  def transaction_params
    params.permit(:amount, :target_wallet_id)
  end
end
