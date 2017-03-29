class Users::SessionsController < Devise::SessionsController
# before_action :configure_sign_in_params, only: [:create]




def edit
  @notifyActivities = PublicActivity::Activity.where(:recipient_id => current_user.id, :owner_type => 'User').order('created_at DESC').reject{|activity| (activity.key == "post.destroy, post.unlike") }
  super
end






  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end





