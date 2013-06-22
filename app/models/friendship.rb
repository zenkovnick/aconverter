class Friendship < ActiveRecord::Base
  attr_accessible :create, :destroy, :friend_id, :user_id
end
