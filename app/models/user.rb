class User < ActiveRecord::Base
  attr_accessible :handle, :name, :provider, :uid
  validates :name, :presence => true, :length => {:minimum => 2, :maximum => 40}
  validates :handle, :presence => true, :length => {:minimum => 3, :maximum => 50}
  validates_format_of :handle, :with => /^[a-zA-Z0-9_\-#!@.,\^\$\*]*\Z/
  validates :provider, :presence => true, :length => {:maximum => 150}
  validates :uid, :presence => true, :length => {:maximum => 500}

  def self.find_by_omniauth(auth)
    where(auth.slice("provider", "uid")).first
  end

  def self.from_omniauth(auth)
    where(find_by_omniauth(auth) || create_from_omniauth(auth)) if auth
  end

  def self.create_from_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["name"]
      #user.first_name = auth["info"]["first_name"]
    end
  end
end
