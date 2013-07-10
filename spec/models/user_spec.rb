require 'spec_helper'

describe User do
  subject { Fabricate(:user) }
  #before(:all) do
  #  @user = User.create(:id => '1', :email => 'user@test.com', :password => Devise.friendly_token[0..20])
  #  @friend = User.create(:id => '2', :email => 'friend@test.com', :password => Devise.friendly_token[0..20])
  #  @friendship = Friendship.create(:user => @user, :friend => @friend, :is_active => true)
  #end

  describe 'user must have email' do
    its(:email) {should_not be_empty}
  end

  describe 'user must have password' do
    its(:password) {should_not be_empty}
  end

  describe 'instance' do
    it 'should be an instance of' do
      subject.should be_an_instance_of User
    end
  end


  describe 'user friendship' do
    before(:each) do
      @friend = Fabricate(:user)
      @friendship = Fabricate(:friendship, :user => subject, :friend => @friend, :is_active => true)
    end

    it 'friendship' do
      subject.friendships.first.is_active.should eq true
    end

    it 'has friend' do
      subject.friendships.count.should be > 0
      subject.inverse_friendships.count.should eq 0
    end

    it 'is friend' do
      @friend.friendships.count.should eq 0
      @friend.inverse_friendships.count.should be > 0
    end

  end

  it 'delete user' do
    subject.destroy
    lambda { subject.reload }.should raise_error(ActiveRecord::RecordNotFound)
  end


end