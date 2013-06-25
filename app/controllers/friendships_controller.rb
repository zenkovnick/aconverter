class FriendshipsController < ApplicationController
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
    @friendship = current_user.friendships.find(params[:id])
    @friendship.destroy
    flash[:notice] = 'Removed friendship.'
    redirect_to current_user
  end
end
