class User < ActiveRecord::Base

  has_many  :events

  validates_presence_of :name
  validates_uniqueness_of :name
  validates_format_of :name, :with => /^\w+$/i, :message => "user name can only contain letters and numbers"
   
  validates_presence_of :identity_url
  validates_uniqueness_of :identity_url

  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create

  def admin?
    return true if self.name == "benchristen" and self.identity_url == "http://benchristen.myopenid.com/"
    return false
  end
  
end
