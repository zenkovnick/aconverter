require "spec_helper"
describe UsersController do
  fixtures :users, :user_files
  describe "GET #index" do
    it "responds successfully with an HTTP 200 status code" do
      sign_in users(:foo)
      get :index
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "renders the index template" do
      sign_in users(:foo)
      get :index
      expect(response).to render_template("index")
    end
  end
  describe "GET #search" do
    it "renders the template" do
      sign_in users(:foo)
      get :search
      expect(response).to be_success
      expect(response.status).to eq(200)
      expect(response).to render_template("search")
    end
  end
  describe "GET #show" do
    it "renders the audio files template" do
      sign_in users(:foo)
      get :show, {:id => users(:foo).id}
      expect(response).to be_success
      expect(response.status).to eq(200)
      expect(response).to render_template("show")
    end
  end
end