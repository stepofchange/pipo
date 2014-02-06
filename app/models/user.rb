class User < ActiveRecord::Base
	before_save { self.email = email.downcase }
	validates :name, presence: true, length: { maximum: 20 }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, 
    					uniqueness: { case_sensitive: false }
    has_secure_password						
    validates :password, length: { minimum: 6 }		
    has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }
    						
end
