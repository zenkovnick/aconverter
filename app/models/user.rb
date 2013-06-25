class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :nickname, :provider, :url, :username

  has_many :user_files
  has_many :friendships
  has_many :friends, :through => :friendships
  has_many :inverse_friendships, :class_name => 'Friendship', :foreign_key => 'friend_id'
  has_many :friends, :through => :inverse_friendships, :source => :user

  def is_friend?(user)
    friendship = Friendship.where(:user_id => self.id, :friend_id => user.id).first
    !friendship.nil?
  end

  def is_active_friend?(user)
    friendship = Friendship.where(:user_id => self.id, :friend_id => user.id).first
    unless friendship.nil?
      friendship.is_active
    end

  end
end
