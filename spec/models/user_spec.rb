# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  password_digest :string(255)
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#

require 'spec_helper'

describe User do

	def create_user set_password_fields:
		user = User.new(
			name: 'User name', 
			email: 'user@mail.com')

		if set_password_fields
			user.password = user.password_confirmation = 'password'
		end

		return user
	end

	subject { @user }

	before do 
		@user = create_user set_password_fields: true
		User.delete_all
	end

	it { should respond_to :name }
	it { should respond_to :email }
	it { should respond_to :password_digest }

	it { should be_valid }

	describe "when name is blank" do
		before { @user.name = " " } # blank? method does not tolerate whitespaces
		it { should_not be_valid }
	end

	describe "when email is blank" do
		before { @user.email = " " }
		it { should_not be_valid }
	end

	describe "when name is too long" do
		before { @user.name = 'a' * (User.maxNameLength + 1) }
		it { should_not be_valid } 
	end

	describe "when email format is valid" do
		before { @user.email = 'suppoted+format@mail.com' }
		it { should be_valid }
	end

	describe "when email format is invalid" do
		before { @user.email = 'unsupported@email_format.com' }
		it { should_not be_valid }
	end

	describe 'email is stored in lowercase' do
		before do 
			@user = create_user set_password_fields: true
			@user.email.upcase!
			@user.save

			@user.reload
		end

		subject { @user.email }

		it { should == @user.email.downcase }
	end

	describe 'when email is not unique (case insensitive)' do
		before do 
			@user = create_user set_password_fields: true 
			@user.save

			@user_with_same_email = @user.dup
			@user_with_same_email.email.upcase!
		end

		subject { @user_with_same_email }

		it { should_not be_valid }

		describe 'save attempt' do
			subject { @user_with_same_email.save }
			it { should be_falsey }
		end
	end

	describe "secure password" do

		before { @user = create_user set_password_fields: false }

		describe "when password is blank" do
			before { @user.password = " " }
			it { should_not be_valid }
		end

		describe "when password is too short" do
			before { @user.password = "a" * (User.minPasswordLength - 1) }
			it { should_not be_valid }
		end

		describe "when password_confirmation is nil" do
			before { @user.password_confirmation = nil }
			it { should_not be_valid }
		end

		describe "when password is not blank" do
			before { @user.password = 'not blank password' }

			describe "when password_confirmation matches password" do
				before { @user.password_confirmation = @user.password }
				it { should be_valid }
			end

			describe "when password_confirmation does not match password" do
				before { @user.password_confirmation = @user.password + 'random part' }
				it { should_not be_valid }
			end
		end

		describe "authenticate method behavior" do
			before { @user.password = "password" }
			subject { @user.authenticate(password) }

			describe "with invalid password being provided" do
				let(:password) { @user.password + 'invalid' }
				it { should be_equal false }
			end

			describe "with valid password being provided" do
				let(:password) { @user.password }
				it { should be_equal @user }
			end
		end

	end

end
