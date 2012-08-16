class User < ActiveRecord::Base
  attr_accessible :handle, :name, :provider, :uid, :email, :poster_width
  validates :name, :presence => true, :length => {:minimum => 2, :maximum => 40}
  validates :handle, :presence => true, :length => {:minimum => 3, :maximum => 50}
  validates_format_of :handle, :with => /^[a-zA-Z0-9\-_\.]*\Z/
  validates :provider, :presence => true, :length => {:maximum => 150}
  validates :uid, :presence => true, :length => {:maximum => 500}
  validates :poster_width, :numericality => {:only_integer => true, :less_than => 250, :greater_than =>  50}, :allow_nil => true
  validates_format_of :email, :with => /(\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z)|(^$)/
  validates_uniqueness_of :handle
  validate :handle_is_not_a_route

  has_many :posters
  has_one :export

  before_save :default_values

  def self.find_by_omniauth(auth)
    where(auth.slice("provider", "uid")).first
  end

  def self.new_from_omniauth(auth)
    User.new(:provider => auth["provider"], :uid=> auth["uid"])
  end

  def self.from_omniauth(auth)
    find_by_omniauth(auth) || new_from_omniauth(auth) if auth
  end

  def to_param
    handle
  end

  private

  def default_values
    self.poster_width ||= 100
  end

  protected
  def handle_is_not_a_route
    return unless handle =~ /^[a-zA-Z0-9_\-#!@.,\^\$\*]*\Z/
    match = Rails.application.routes.recognize_path("/#{handle}")
    unless !match or (match and match[:controller]=='users')
      errors.add(:handle, "conflicts with existing path (/#{handle})")
    end
  end
end
