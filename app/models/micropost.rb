class Micropost < ActiveRecord::Base
	belongs_to :user
    default_scope -> { order('created_at DESC') }
    validates :content, presence: true, length: { maximum: 254 }
    validates :user_id, presence: true
    has_attached_file :image,
     :styles => { :medium => "300x300>", :thumb => "100x100>", :small => "50x50" }

    def self.from_users_followed_by(user)
      followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
      where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
            user_id: user.id)
    end
end
