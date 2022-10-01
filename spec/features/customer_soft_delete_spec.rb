require 'rails_helper'

RSpec.feature 'Customer is deleted', type: :feature do
  scenario 'they are no longer shown on default queries' do
    customer = create(:customer)

    expect(Customer.count).to eq(1)

    customer.delete

    expect(Customer.count).to eq(0)

    expect(Customer.unscoped.count).to eq(1)
  end

  context 'they are restore after being deleted' do
    it 'is shown again on queries' do
      customer = create(:customer)

      customer.delete

      customer.restore!

      expect(Customer.count).to eq(1)
    end
  end

  context 'if another user was created with same email' do
    it 'cannot be restored' do
      customer = create(:customer)

      customer.delete

      create(:customer, email: customer.email)

      expect(Customer.unscoped.count).to eq(2)

      customer.restore!

      expect(Customer.count).to eq(1)
    end
  end

  context 'if another user was created with same username' do
    it 'cannot be restored' do
      customer = create(:customer)

      customer.delete

      create(:customer, username: customer.username)

      expect(Customer.unscoped.count).to eq(2)

      customer.restore!

      expect(Customer.count).to eq(1)
    end
  end
end
