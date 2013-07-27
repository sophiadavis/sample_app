class Micropost < ActiveRecord::Base
	attr_accessible :content #, :user_id# should not be accessible!
	
	belongs_to :user
	  
	validates :user_id, presence: true
	validates :content, presence: true, length: { maximum: 140 }
	
	default_scope order: 'microposts.created_at DESC' # DESC = sql for "descending"
end