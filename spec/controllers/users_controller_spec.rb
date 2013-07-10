require 'spec_helper'
require 'rspec/autorun'

RSpec::Matchers::define :have_link_or_button do |text|
  match do |page|
    Capybara.string(page.body).has_selector?(:link_or_button, text: text)
  end
end

describe UsersController do
  render_views
  before :each do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = Fabricate(:user)
    @user_search = Fabricate(:user)
    sign_in @user
  end
  describe "GET #index" do
    it "responds successfully with an HTTP 200 status code" do
      get :index
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
  end
  describe "GET #show" do
    it "renders the audio files template" do
      get :show, {:id => @user.id}
      expect(response).to be_success
      expect(response.status).to eq(200)
      expect(response).to render_template("show")
    end
  end

  describe "GET #search" do
    it "execute search me" do
      visit new_user_session_path

      fill_in 'user[email]', :with => @user.email
      fill_in 'user[password]', :with => @user.password

      find(:xpath, '//input[@type="submit"]').click

      visit users_search_path

      page.should have_content("Find new friends")

      fill_in 'Email', :with => @user.email
      click_button "Search"

      page.should have_content('It is You')
    end

    it "execute add friend" do
      # First User Login
      visit new_user_session_path

      fill_in 'user[email]', :with => @user.email
      fill_in 'user[password]', :with => @user.password

      find(:xpath, '//input[@type="submit"]').click

      # First User Find Friend
      visit users_search_path

      page.should have_content("Find new friends")

      fill_in 'Email', :with => @user_search.email
      click_button "Search"

      page.should have_selector('ul.search-results a.btn-success')
      # First User Add Friend
      click_link "Add to friends"

      page.should have_content("Added friend. Wait for confirmation")

      # First User Sign Out
      click_link "Logout"

      # Second User Login
      visit new_user_session_path

      fill_in 'user[email]', :with => @user_search.email
      fill_in 'user[password]', :with => @user_search.password

      find(:xpath, '//input[@type="submit"]').click

      # Second User Find Friend
      visit users_search_path

      page.should have_content("Find new friends")

      fill_in 'Email', :with => @user.email
      click_button "Search"

      page.should have_selector('ul.search-results a.btn-success')

      # Second User Add Friend
      click_link "Add to friends"

      page.should have_content("Added friend. Now you are friends")

    end


  end

end