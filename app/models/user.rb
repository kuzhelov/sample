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

class User < ActiveRecord::Base
	
	class << self
		def maxNameLength() 50 end
	end

	validates :name, presence: true, length: { maximum: self.maxNameLength }
	validates :email, presence: true, format: { with: /\A[+\w\-]+@[a-z0-9\-]+[.][a-z]+\z/i }

end
