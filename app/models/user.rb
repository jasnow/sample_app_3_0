# == Schema Information
# Schema version: 20110501231616
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email_address      :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#

require 'digest'

class User < ActiveRecord::Base
  attr_accessor   :password
  attr_accessible :name, :email_address, :password, :password_confirmation

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name,  :presence => true, :length => { :maximum => 50 }
  validates :email_address, :presence => true, 
                    :format => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false }

  # Automatically create the virtual attribute 'password_confirmation'.
  validates :password,  :presence => true,
                        :confirmation => true,
                        :length => { :within => 6..40 }

  before_save :encrypt_password

  # Returns true if the user password matches the submitted password.
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end

  # Listing 7.27:
#  def User.authenticate(email_address, submitted_password)
#    user = find_by_email_address(email_address)
#    return nil  if user.nil?
#    return user if user.has_password?(submitted_password)
#  end

  # Listing 7.28:
#  def self.authenticate(email_address, submitted_password)
#    user = find_by_email_address(email_address)
#    return nil  if user.nil?
#    return user if user.has_password?(submitted_password)
#    return nil
#  end

  # Listing 7.29:
#  def self.authenticate(email_address, submitted_password)
#    user = find_by_email_address(email_address)
#    if user.nil?
#      nil
#    elsif user.has_password?(submitted_password)
#      user
#    else
#      nil
#    end
#  end

  # Listing 7.30:
#  def self.authenticate(email_address, submitted_password)
#    user = find_by_email_address(email_address)
#    if user.nil?
#      nil
#    elsif user.has_password?(submitted_password)
#      user
#    end
#    # Implicit return
#  end

  # Listing 7.31:
  def self.authenticate(email_address, submitted_password)
    user = find_by_email_address(email_address)
    user && user.has_password?(submitted_password) ? user : nil
  end

  private
    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
    end

    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end

    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
end