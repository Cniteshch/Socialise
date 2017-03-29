class PostsController < ApplicationController
before_action  :authenticate_user!
before_action :set_post, only: [:show, :edit, :update, :destroy]
before_action :load_activities, only: [:index, :show, :new, :edit]

def like
  @post = Post.find params[:id]

    @post.liked_by current_user
    @post.create_activity(:liked, owner: current_user, recipient: @post.user)

    redirect_to :back
end

def unlike
  @post = Post.find params[:id]
  @post.unliked_by current_user
   @activity = PublicActivity::Activity.where(trackable_id: @post.id, owner_id: current_user.id, key: "post.liked")
    @activity.destroy_all

    redirect_to :back
end




def new 
@post = current_user.posts.new
end


def index
@posts = Post.order(created_at: :desc)
end


def user_post
@posts = current_user.posts.order(created_at: :desc)
end

def show
	

@post = Post.find params[:id]

end

def create 

	session[:return_create] ||= request.referer
	@post = current_user.posts.new(post_params)
	
    if @post.save
      @post.liked_by @user
      @post.votes_for.size
       @post.create_activity(:posted, owner: current_user)
    redirect_to session.delete(:return_create)
else redirect_to session.delete(:return_create), notice: @post.errors.full_messages.first
end
    
end

  def edit
  	session[:return_to] ||= request.referer
 unless @post.user_id == current_user.id
      flash[:notice] = 'Access denied!! as post doesnt belong to you!'
redirect_to session.delete(:return_to)
	end	
  end

  def update
session[:return_update] ||= request.referer
  	@post = Post.find params[:id]
    if  @post.update(post_params)
      @post.create_activity(:updated, owner: current_user, recipient: @post.user)
     

     redirect_to session.delete(:return_to)

else redirect_to edit_post_path
  end
end


  def destroy
    session[:return_destroy] ||= request.referer
    @post.destroy
    
     if params[:from]=='post'
    redirect_to session.delete(:return_destroy)
  
else
    redirect_to root_path
    
    end
  end
private

def set_post
    @post = Post.find(params[:id])
  end
def load_activities  
  @activities = PublicActivity::Activity.where(trackable_type: "Post").order('created_at DESC').limit(20).reject{|activity| (activity.key == "post.destroy, post.unlike") }
   @friendActivities = PublicActivity::Activity.where(trackable_type: "Post",:owner_id => current_user.following_users, :owner_type => 'User').order('created_at DESC').limit(10).reject{|activity| (activity.key == "post.destroy, post.unlike") }

  @notifyActivities = PublicActivity::Activity.where(:recipient_id => current_user.id, :owner_type => 'User').order('created_at DESC').reject{|activity| (activity.key == "post.destroy, post.unlike") }
end

def post_owner
     unless @post.user_id == current_user.id
      flash[:notice] = 'Access denied as you are not owner of this Comment'
      redirect_to root_path
     end
    end
 def post_params

params.require(:post).permit(:name, :body)

end


end
