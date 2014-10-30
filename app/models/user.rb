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

class User < ActiveRecord::Base
	
	class << self
		def maxNameLength() 50 end
		def minPasswordLength() 7 end
	end

	has_secure_password

	validates :name, presence: true, length: { maximum: self.maxNameLength }
	validates :email, presence: true, format: { with: /\A[+\w\-]+@[a-z0-9\-]+[.][a-z]+\z/i }

	validates :password, presence: true, length: { minimum: self.minPasswordLength }

end
