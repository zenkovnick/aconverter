require 'spec_helper'

describe User do
  fixtures :users, :friendships

  #before(:all) do
  #  @user = User.create(:id => '1', :email => 'user@test.com', :password => Devise.friendly_token[0..20])
  #  @friend = User.create(:id => '2', :email => 'friend@test.com', :password => Devise.friendly_token[0..20])
  #  @friendship = Friendship.create(:user => @user, :friend => @friend, :is_active => true)
  #end

  describe 'user properties and abilities' do
    it 'has a email' do
      users(:foo).email.should eq 'foo@example.com'
      users(:bar).email.should eq 'bar@example.com'
    end
  end

  describe 'user friendship' do
    it 'has active status' do
      users(:foo).friendships.first.is_active.should eq true
      users(:bar).inverse_friendships.first.is_active.should eq true
    end

    it 'has friend' do

      users(:foo).friendships.count.should be > 0
      users(:foo).inverse_friendships.count.should eq 0
    end

    it 'is friend' do
      users(:bar).friendships.count.should eq 0
      users(:bar).inverse_friendships.count.should be > 0
    end

  end
end