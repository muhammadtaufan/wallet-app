require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is invalid if password and password_confirmation do not match' do
    user = build(:user, password: 'password', password_confirmation: 'different')
    expect(user).not_to be_valid
  end

  it 'generates a token before creation' do
    user = create(:user)
    expect(user.token).not_to be_nil
  end

  it 'invalidates the token' do
    user = create(:user)
    user.invalid_token
    expect(user.reload.token).to be_nil
  end

  it 'has a wallet after creation' do
    user = create(:user)
    expect(user.wallet).not_to be_nil
  end
end
