class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, 
         :recoverable, :rememberable, :trackable, :validatable

 has_many :posts, dependent: :destroy
 acts_as_voter
acts_as_follower
acts_as_followable


extend FriendlyId
friendly_id :name, use: :slugged 




validates :name, presence: true

include PublicActivity::Model

  mount_uploader :avatar, ImageUploader
end

private

def should_generate_new_friendly_id?
  slug.nil? || name_changed? 
end
