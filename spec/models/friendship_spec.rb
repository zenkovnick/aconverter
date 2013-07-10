require 'spec_helper'

describe Friendship do
  subject { Fabricate(:friendship) }

  describe 'user must an instance of User' do
    its(:user) {should be_an_instance_of User}
  end

  describe 'friend must an instance of User' do
    its(:friend) {should be_an_instance_of User}
  end

  describe 'status must be false' do
    its(:is_active) {should eq false}
  end

  describe 'instance' do
    it 'should be an instance of' do
      subject.should be_an_instance_of Friendship
    end
  end

  it 'delete user file' do
    subject.destroy
    lambda { subject.reload }.should raise_error(ActiveRecord::RecordNotFound)
  end


end