class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable,
         :omniauth_providers => [:facebook, :vkontakte, :twitter]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :nickname, :provider, :url, :username

  has_many :user_files
  has_many :friendships
  has_many :friends, :through => :friendships
  has_many :inverse_friendships, :class_name => 'Friendship', :foreign_key => 'friend_id'
  has_many :friends, :through => :inverse_friendships, :source => :user

  def is_my_friend?(user)
    friendship = Friendship.where(:user_id => self.id, :friend_id => user.id).first
    !(friendship.nil?)
  end

  def is_friend?(user)

    friendship = Friendship.where(:user_id => self.id, :friend_id => user.id).first
    if friendship.nil?
      inverse_friendship = Friendship.where(:user_id => user.id, :friend_id => self.id).first
    else
      inverse_friendship = nil
    end
    !(friendship.nil? && inverse_friendship.nil?)
  end

  def is_active_friend?(user)
    friendship = Friendship.where(:user_id => self.id, :friend_id => user.id).first
    if friendship.nil?
      inverse_friendship = Friendship.where(:user_id => user.id, :friend_id => self.id).first
      unless inverse_friendship.nil?
        is_active = inverse_friendship.is_active
      end
    else
      is_active = friendship.is_active
    end
    return is_active
  end
  def self.find_for_facebook_oauth access_token
    if user = User.where(:url => access_token.info.urls.Facebook).first
      user
    else
      User.create!(:provider => access_token.provider, :url => access_token.info.urls.Facebook, :username => access_token.extra.raw_info.name, :nickname => access_token.extra.raw_info.username, :email => "#{access_token.extra.raw_info.username}@fb.com", :password => Devise.friendly_token[0,20])
    end
  end
  def self.find_for_vkontakte_oauth access_token
    if user = User.where(:url => access_token.info.urls.Vkontakte).first
      user
    else
      puts access_token.extra.raw_info.domain
      User.create!(:provider => access_token.provider, :url => access_token.info.urls.Vkontakte, :username => access_token.info.name, :nickname => access_token.extra.raw_info.domain, :email => "#{access_token.extra.raw_info.screen_name}@vk.com", :password => Devise.friendly_token[0,20])
    end
  end
  def self.find_for_twitter_oauth access_token
    if user = User.where(:url => access_token.info.urls.Twitter).first
      user
    else
      User.create!(:provider => access_token.provider, :url => access_token.info.urls.Twitter, :username => access_token.info.name, :nickname => access_token.extra.raw_info.domain, :email => "#{access_token.extra.raw_info.screen_name}@tw.com", :password => Devise.friendly_token[0,20])
    end
  end

end
