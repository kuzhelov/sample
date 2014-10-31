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

class User < ActiveRecord::Base
	
	class << self
		def maxNameLength() 50 end
		def minPasswordLength() 7 end
	end

	before_save do |record|
		record.email.downcase!
	end

	has_secure_password

	validates :name, presence: true, length: { maximum: self.maxNameLength }
	validates :email, 
		presence: true, 
		format: { with: /\A[+\w\-]+@[a-z0-9\-]+[.][a-z]+\z/i },
		uniqueness: { case_sensitive: false }

	validates :password, presence: true, length: { minimum: self.minPasswordLength }

end
