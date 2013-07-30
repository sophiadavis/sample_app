# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#  remember_token  :string(255)
#  admin           :boolean          default(FALSE)
#

class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation # admin is not on this list!
  has_secure_password
  
  has_many :microposts, 	dependent: :destroy
  has_many :relationships, 	foreign_key: "follower_id", 
  							dependent: :destroy
  has_many :followed_users, through: :relationships, 
  							source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id",
  							class_name: "Relationship",
  							dependent: :destroy
  has_many :followers, through: :reverse_relationships, 
  							source: :follower

#   before_save { self.email = email.downcase } RAILS 4
  before_save { |user| user.email = email.downcase }
#   before_save { email.downcase! } # works too
  before_save :create_remember_token
#   before_create :create_remember_token RAILS 4
  
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: 	true, 
  					format: 	{ with: VALID_EMAIL_REGEX },
  					uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true
  after_validation { self.errors.messages.delete(:password_digest) }

	def User.new_remember_token
		Digest::SHA1.hexdigest(token.to_s)
	end
	
	def feed
# 		Micropost.where("user_id = ?", id)
		Micropost.from_users_followed_by(self)
	end
	
	def following?(other_user)
		relationships.find_by_followed_id(other_user.id)
	end
	
	def follow!(other_user)
		relationships.create!(followed_id: other_user.id)
	end
	
	def unfollow!(other_user)
		relationships.find_by_followed_id(other_user.id).destroy
	end
	
	private
#   RAILS 4
# 		def create_remember_token
# 			self.remember_token = User.encrypt(User.new_remember_token)
# 		end

		def create_remember_token
			self.remember_token = SecureRandom.urlsafe_base64
		end
end
