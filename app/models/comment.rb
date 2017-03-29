class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :user
validates_presence_of :commentbody
  has_many :activities, as: :trackable, class_name: 'PublicActivity::Activity', dependent: :destroy
include PublicActivity::Model





end
