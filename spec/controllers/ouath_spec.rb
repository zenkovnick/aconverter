require 'spec_helper'
require 'omniauth_helper'

describe Users::OmniauthCallbacksController, "handle facebook authentication callback" do

  describe "FB Omniauth" do
    before do
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:fb]
    end
    it "sets a session variable to the OmniAuth auth hash" do
      request.env["omniauth.auth"]['uid'].should == '1234'
    end

  end
  describe "VK Omniauth" do
    before do
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:vk]
    end
    it "sets a session variable to the OmniAuth auth hash" do
      request.env["omniauth.auth"]['uid'].should == '1212'
    end

  end
  describe "TW Omniauth" do
    before do
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:tw]
    end
    it "sets a session variable to the OmniAuth auth hash" do
      request.env["omniauth.auth"]['uid'].should == '4321'
    end

  end
end