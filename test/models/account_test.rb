require 'test_helper'

class AccountTest < ActiveSupport::TestCase
	def setup
	@client = Client.create!(
	name: 'Jan', surname: 'Nowak',
	email: 'jan@wp.pl', phone: '234-534-333')
	@account = @client.accounts.create!
	end

	test "init" do
	a = @client.accounts.new
	end

	test "number" do
	assert @account.number.present?
	assert @account.number > 1
	end

	test "balance is zero" do
	assert_equal 0, @account.balance
	end
	
	test "balance validator" do
	@account.balance = 'ala'
	assert @account.invalid?
	assert @account.errors[:balance].any?
	@account.balance = 1000
	assert @account.valid?
	assert @account.errors[:balance].empty?
	end

	test "update_balance" do
	@account.transactions.create(amount: 100, descr: 'wpłata 1')
	@account.reload
	@account.transactions.create(amount: 250, descr: 'wpłata 2')
	@account.reload
	@account.transactions.create(amount: -50, descr: 'wypłata 1')
	assert_equal 300, @account.balance	
	end
end
