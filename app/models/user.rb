# Copyright 2009 Swansea University
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

require 'digest/sha1'

class User < ActiveRecord::Base

  composed_of :name,
    :class_name => "Name",
    :mapping => [
    # database  ruby
    %w[ title title ],
    %w[ first_name first ],
    %w[ last_name last ],
    %w[ initials initials ],
    %w[ known_as known_as ]
  ],
    :allow_nil => true

  has_one :student, :dependent => :destroy
  #accepts_nested_attributes_for :student, :allow_destroy => true

  has_one :supervisor, :dependent => :destroy
  #accepts_nested_attributes_for :supervisor, :allow_destroy => true

  has_many :projects, :dependent => :nullify

  #has_one :coordinator, :dependent => :nullify
  
  # ---------------------------------------
  # The following code has been generated by role_requirement.
  # You may wish to modify it to suit your need
  has_and_belongs_to_many :roles
  
  # has_role? simply needs to return true or false whether a user has a role or not.  
  # It may be a good idea to have "admin" roles return true always
  def has_role?(role_in_question)
    return true if self.roles.find_by_name("admin")
    return self.roles.find_by_name(role_in_question)
  end
  # ---------------------------------------
  
  # Assign a role
  def add_role(role)
    return if self.has_role?(role.name)
    self.roles << role
  end

  def delete_role(role)
    return unless role = self.has_role?(role.name)
    self.roles.delete(role)
  end
  
  
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken

  validates_presence_of     :login
  validates_length_of       :login,    :within => 3..40
  validates_uniqueness_of   :login
  validates_format_of       :login,    :with => Authentication.login_regex, :message => Authentication.bad_login_message



  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message

  #validates_associated :name
  

  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :name, :password, :password_confirmation,
    :title, :first_name, :last_name, :known_as, :initials, :role_ids



  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    u = find_by_login(login.downcase) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end

  def is_owner?(project)
    if logged_in?
      return project.created_by == @current_user
    end
    false
  end

  def change_password!(old_password, new_password, new_confirmation)
    errors.add_to_base("New password does not match the password confirmation.") and
      return false if (new_password != new_confirmation)
    errors.add_to_base("New password cannot be blank.") and
      return false if new_password.blank?
    errors.add_to_base("You password was not changed, your old password is incorrect.") and
      return false unless self.authenticated?(old_password)
    self.password, self.password_confirmation = new_password, new_confirmation
    save
  end
  protected
    


end


