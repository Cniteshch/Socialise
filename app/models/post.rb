class Post < ActiveRecord::Base
  belongs_to :user
  has_many :comments, dependent: :destroy

validates_presence_of :body

  
acts_as_votable

include PublicActivity::Model
has_many :activities, as: :trackable, class_name: 'PublicActivity::Activity', dependent: :destroy

 mount_uploader :name, ImageUploader
end
