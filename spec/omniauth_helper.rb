RACK_ENV = ENV['ENVIRONMENT'] ||= 'test'
OmniAuth.config.test_mode = true
omniauth_facebook =
    {:provider => "facebook",
     :uid      => "1234",
     :info   => {:name       => "John Doe",
                 :email      => "johndoe@email.com"},
     :credentials => {:token => "testtoken234tsdf"}}

omniauth_twitter =
    {:provider => "twitter",
     :uid      => "4321",
     :info   => {:name       => "John Doe",
                 :email      => "johndoe@email.com"},
     :credentials => {:token => "testtoken234tsdf"}}

omniauth_vk =
    {:provider => "vk",
     :uid      => "1212",
     :info   => {:name       => "John Doe",
                 :email      => "johndoe@email.com"},
     :credentials => {:token => "testtoken234tsdf"}}


OmniAuth.config.add_mock(:fb, omniauth_facebook)
OmniAuth.config.add_mock(:tw, omniauth_twitter)
OmniAuth.config.add_mock(:vk, omniauth_vk)