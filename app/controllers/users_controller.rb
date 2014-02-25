class UsersController < ApplicationController
  before_action :signed_in_user,
                only: [:index, :edit, :update, :destroy, :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :skip_password_attribute, only: :update

  def new
  	@user = User.new
  end

  def index
    @users = User.all
  end  

  def show
  	@user = User.find(params[:id])
    @microposts = @user.microposts(page: params[:page])
    if signed_in?
      @micropost  = current_user.microposts.build
    end
  end	

  def create
  	@user = User.new(user_params)   
    if @user.save
      UserMailer.registration_confirmation(@user).deliver
        flash[:success] = "Please cofirm email!"
        redirect_to root_url
    else
      render 'new'
    end
  end

  def email_verified
    @user = User.find_by_token_confirm(params[:token_confirm])
    @user.update_attribute(:confirm_email, true)
    if @user.save
      redirect_to root_url, flash[:success] => "Email has been verified."
    else
      redirect_to root_url, flash[:error] => "Email has NOT been verified."
    end
  end

  def edit
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_edit_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to users_url
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers(page: params[:page])
    render 'show_follow'
  end

private

	def user_params
	  params.require(:user).permit(:avatar, :name, :email, :password,
	                                   :password_confirmation)
	end

  def user_edit_params
    params.require(:user).permit(:avatar, :name, :email)
  end

  def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
  end

  def skip_password_attribute
    if params[:password].blank? && params[:password_validation].blank?
      params.except!(:password, :password_validation)
    end
  end

end