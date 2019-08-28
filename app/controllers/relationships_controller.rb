class RelationshipsController < ApplicationController
  before_action :logged_in_user
  before_action :load_user, only: :create

  def create
    current_user.follow(@user)
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end

  def destroy
    @user = find_id_followed
    current_user.unfollow(@user)
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end

  private
  def find_id_followed
    @followed = Relationship.find_by(id: params[:id]).followed
    if @followed
      @followed
    else
      flash.now[:danger] = I18n.t "controller.relationships.not_found"
      redirect_back
    end
  end

  def load_user
    @user = User.find_by id: params[:followed_id]
    return if @user
    flash.now[:danger] = I18n.t "controller.relationships.not_found"
    redirect_back
  end
end
