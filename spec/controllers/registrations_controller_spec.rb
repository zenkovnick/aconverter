require 'spec_helper'

describe RegistrationsController do
  render_views
  describe 'User profile' do
    it 'update' do
      @user = Fabricate(:user)

      visit new_user_session_path
      fill_in 'user[email]', :with => @user.email
      fill_in 'user[password]', :with => @user.password
      find(:xpath, '//input[@type="submit"]').click


      visit edit_user_registration_path @user
      click_button 'Update'
      page.should have_content 'You updated your account successfully.'
    end
  end

end