class UsersController < ApplicationController
  before_action :load_user, except: [:index, :new, :create]
  before_action :logged_in_user, except: [:show, :new, :create]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.paginate(page: params[:page], per_page: Settings.per_page)
  end

  def show
    return if @user
    flash.now[:danger] = t ".not_found"
    render :show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash.now[:success] = t ".success"
      redirect_to @user
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = t ".update_success"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    action_destroy = @user.destroy
    if action_destroy
      flash[:success] = t ".deleted"
    else
      flash[:danger] = t ".not_delete"
    end
    redirect_to users_url
  end

  private
  def user_params
    params.require(:user).permit :name, :email,
      :password, :password_confirmation
  end

  def logged_in_user
    store_location unless logged_in?
    flash[:danger] = t ".please_login" unless logged_in?
    redirect_to login_url unless logged_in?
  end

  def correct_user
    redirect_to(root_url) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

  def load_user
    @user = User.find_by(id: params[:id])
    flash[:danger] = t ".user_notfound" unless @user
    redirect_to root_path unless @user
  end
end
