class UsersController < ApplicationController
  before_action :authenticate_user!

before_action :load_activities, only: [:index, :show, :edit]
  


  def index
    @users = User.all
  end


def follow
    @user = User.find(params[:id])
    current_user.follow(@user)
    @user.create_activity(:follow, owner: current_user, recipient: @user)

    redirect_to :back
  end

def unfollow
    @user = User.find(params[:id])
    current_user.stop_following(@user)
    @activity = PublicActivity::Activity.where(trackable_id: @user.id, owner_id: current_user.id, key: "user.follow")
    @activity.destroy_all
    redirect_to :back
  end


def edit
  @notifyActivities = PublicActivity::Activity.where(:recipient_id => current_user.id, :owner_type => 'User').order('created_at DESC').reject{|activity| (activity.key == "post.destroy, post.unlike") }
  super
end





  def show 
   
    @user = User.friendly.find(params[:id])
      @userActivities = PublicActivity::Activity.where(trackable_type: "Post",owner_id: @user.id,).order('created_at DESC').limit(8).reject{|activity| (activity.key == "post.destroy, post.unlike") }

  @posts = @user.posts.order(created_at: :desc)  


    
  end

end
private


def load_activities  

  @notifyActivities = PublicActivity::Activity.where(:recipient_id => current_user.id, :owner_type => 'User').order('created_at DESC').limit(10).reject{|activity| (activity.key == "post.destroy, post.unlike") }

end

 
