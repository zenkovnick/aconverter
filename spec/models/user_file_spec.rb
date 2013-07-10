require 'spec_helper'

describe UserFile do
  subject { Fabricate(:user_file) }

  describe 'user file must have owner' do
    its(:user) {should be_an_instance_of User}
  end

  describe 'user file status must be queued from very beggining' do
    its(:status) {should eq 'queued' }
  end

  describe 'instance' do
    it 'should be an instance of' do
      subject.should be_an_instance_of UserFile
    end
  end

  it 'delete user file' do
    subject.destroy
    lambda { subject.reload }.should raise_error(ActiveRecord::RecordNotFound)
  end


end