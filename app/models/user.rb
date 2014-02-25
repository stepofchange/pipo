class User < ActiveRecord::Base
	  has_many :microposts, dependent: :destroy
    has_many :relationships, foreign_key: "follower_id", dependent: :destroy
    has_many :followed_users, through: :relationships, source: :followed
    has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
    has_many :followers, through: :reverse_relationships, source: :follower
	  before_save { self.email = email.downcase }
	  before_create :create_remember_token
    before_create :create_token_confirm
	  validates :name, presence: true, length: { maximum: 20 }
	  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, 
    					uniqueness: { case_sensitive: false }
    has_secure_password						
    validates :password, length: { minimum: 6 }, :if => :should_validate_password?		
    has_attached_file :avatar,
     :styles => { :medium => "300x300>", :thumb => "100x100>", :small => "50x50" }
    attr_accessor :updating_password

    def should_validate_password?
      updating_password || new_record?
    end

    def User.new_remember_token
      SecureRandom.urlsafe_base64
    end

    def User.encrypt(token)
      Digest::SHA1.hexdigest(token.to_s)
    end

    def feed
      Micropost.from_users_followed_by(self)
    end

    def following?(other_user)
      relationships.find_by(followed_id: other_user.id)
    end

    def follow!(other_user)
      relationships.create!(followed_id: other_user.id)
    end

    def unfollow!(other_user)
      relationships.find_by(followed_id: other_user.id).destroy
    end

    private

      def create_remember_token
        self.remember_token = User.encrypt(User.new_remember_token)
      end 

      def create_token_confirm
        self.token_confirm = User.encrypt(User.new_remember_token)
      end  						
end
