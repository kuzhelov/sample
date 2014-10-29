# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe User do

	subject { @user }

	before { @user = User.new(name: 'User name', email: 'user@mail.com') }

	it { should respond_to :name }
	it { should respond_to :email }

end
