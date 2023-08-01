class Api::V1::TransactionsController < Api::V1::ApplicationController
  before_action :set_wallet

  def transfer
    if @wallet.transfer(params[:target_wallet_id], params[:amount])
      render json: { message: 'Transfer successful' }, status: :created
    else
      render json: { status: 'error', message: @wallet.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: { status: 'error', message: e.message }, status: :unprocessable_entity
  end

  def withdraw
    @transaction = @wallet.transactions.build(transaction_params.merge(type: 'DebitTransaction'))

    if @transaction.save
      render json: @transaction, status: :created
    else
      render json: @transaction.errors, status: :unprocessable_entity
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

  private

  def set_wallet
    @wallet = Wallet.find(params[:wallet_id])
  end

  def transaction_params
    params.require(:transaction).permit(:amount, :target_wallet_id)
  end
end
