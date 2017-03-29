class CommentsController < ApplicationController
before_action  :authenticate_user!
before_action :set_post, only: [:show, :edit, :update, :destroy]
before_action :load_activities, only: [:index, :show, :new, :edit]

def new 

end
def index

@comments = @post.comment.order(created_at: :desc)

end
def user_post

@comments = @post.comment.order(created_at: :desc)

end

def show
@post = Post.find params[:id]
@comments = @post.comments.order(created_at: :desc)	

end

def create 
	 @post = Post.find(params[:post_id])
	session[:return_create] ||= request.referer
	@comment = @post.comments.new(comment_params)
	@comment.user_id == current_user.id
	@post.create_activity(:commented, owner: current_user, recipient: @post.user)
 if @comment.save
    redirect_to session.delete(:return_create)
else
    
       
    redirect_to session.delete(:return_create), notice: @comment.errors.full_messages.first

end
    
end

  def edit

  	session[:return_to] ||= request.referer
 unless @comment.user_id == current_user.id
      flash[:notice] = 'Access denied!! as you are not owner of this Comment'
redirect_to session.delete(:return_to)
	end	
  end

  def update
  
    if  @comment.update(comment_params)

      redirect_to session.delete(:return_to)
  end
end


  def destroy
    session[:return_destroy] ||= request.referer
  @post = Post.find(params[:post_id])
    @comment.destroy
      @activity = PublicActivity::Activity.where(trackable_id: @post.id, owner_id: current_user.id, key: "post.commented")
    @activity.destroy_all

    respond_to do |format|
      format.js
      format.html {redirect_to session.delete(:return_destroy)}
    end
  end



private

def set_post
    @post = Post.find(params[:post_id])
    @comment = Comment.find(params[:id])
   
  end
def load_activities
  @activities = PublicActivity::Activity.order('created_at DESC').limit(20).reject{|activity| (activity.key == "post.destroy, post.unlike") }
end

def post_owner
     unless @comment.user_id == current_user.id
      flash[:notice] = 'Access denied as you are not owner of this Job'
      redirect_to root_path
     end
    end
 def comment_params

params.require(:comment).permit(:commentbody, :user_id, :post_id)

end
end
