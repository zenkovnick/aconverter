class FriendshipsController < ApplicationController
  before_filter :require_login

  def new_friendship
    @friendship = Friendship.where(:user_id => params[:friend_id], :friend_id => current_user.id).first
    if @friendship.present?
      @friendship.is_active = true
    else
      @friendship = current_user.friendships.build(:friend_id => params[:friend_id])
    end
    if @friendship.save
      flash[:notice] = 'Added friend. Wait for confirmation'
      redirect_to root_url
    else
      flash[:error] = 'Unable to add friend.'
      redirect_to root_url
    end

  end

  def destroy_friendship

    @friendship = current_user.friendships.find_by_friend_id(User.find(params[:friend_id]))
    if @friendship.present?
      @friendship.destroy
      flash[:notice] = 'Removed friendship.'
    else
      @inverse_friendship = current_user.inverse_friendships.find_by_user_id(User.find(params[:friend_id]))
      if @inverse_friendship.present?
        @inverse_friendship.destroy
        flash[:notice] = 'Removed friendship.'
      end
    end

    redirect_to users_path
  end

  protected

  def require_login
    unless user_signed_in?
      #flash[:error] = "You must be logged in to access this section"
      respond_to do |format|
        format.html { redirect_to new_user_session_path }
        format.json { head :no_content }
      end
    end
  end
end
