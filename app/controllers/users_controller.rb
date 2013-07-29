class UsersController < ApplicationController
  before_filter :signed_in_user,	only: [:edit, :update, :index, :destroy, :following, :followers]
  before_filter :correct_user, 		only: [:edit, :update]
  before_filter :admin_user, 		only: [:destroy]
  
  def show
  	@user = User.find(params[:id])
  	@microposts = @user.microposts.paginate(page: params[:page]) 
  end
  
  def new
  	redirect_to(root_path) if signed_in? # signed in users should not be trying to hit this url
  	@user = User.new
  end
  
  def create
#   @user = User.new(user_params)
	redirect_to(root_path) if signed_in?
	@user = User.new(params[:user])
  	if @user.save
  		sign_in @user
  		flash[:success] = "Welcome to the Sample App!"
  		redirect_to @user
  	else
  		render 'new'
  	end
  end
  
  def index
  	@users = User.paginate(page: params[:page])
  end
  
  def edit
  	# @user = User.find(params[:id]) 
  	# don't need this because we added the before filter and
  	# the current_user method to the sessions helper file
  end
  
  def update
  	# @user = User.find(params[:id])
  	# don't need this because we added the before filter and
  	# the current_user method to the sessions helper file
	if @user.update_attributes(params[:user])
		flash[:success] = "Profile updated"
		sign_in @user
		redirect_to @user
	else
		render 'edit'
	end
  end
  
  def destroy
  	user = User.find(params[:id])
  	if (current_user.admin? && current_user?(user)) # why couldn't I just use "user"?
  		flash[:error] = "NO MAN! Don't go deleting yourself. It's not too late. We can still get you help."
  	else
  		user.destroy
		flash[:success] = "User destroyed."
	end
	redirect_to users_path 
  end
  
  def following
  	@title = "Following"
  	@user = User.find(params[:id])
  	@users = @user.followed_users.paginate(page: params[:page])
  	render 'show_follow'
  end
  
  def followers
  	@title = "Followers"
  	@user = User.find(params[:id])
  	@users = @user.followers.paginate(page: params[:page])
	render 'show_follow'
  end

  private
  	
  	def correct_user
  		@user = User.find(params[:id])
  		redirect_to(root_path) unless current_user?(@user)
  	end
  	
  	def admin_user
  		redirect_to(root_path) unless current_user.admin?
  	end
end


  
# rails 4 stuff
#   private
#   	def user_params
#   		params.require(:user).permit(:name, :email, :password, :password_confirmation)
#   	end
