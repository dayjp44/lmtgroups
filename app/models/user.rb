require 'digest/sha1'
class User < ActiveRecord::Base
  acts_as_mappable
  
  belongs_to :role
  
  has_many :members
  has_many :gradings
  has_many :reports, :order => "date_of_meeting DESC"
  has_many :notes, :order => "created_at DESC"
  
  has_many :facilitator_assignments_as_parent, :class_name => "FacilitatorAssignment", :foreign_key => "coach_id", :dependent => :destroy
  has_many :facilitators, :through => :facilitator_assignments_as_parent
  
  has_many :facilitator_assignments_as_child, :class_name => "FacilitatorAssignment", :foreign_key => "facilitator_id", :dependent => :destroy
  has_many :coaches, :through => :facilitator_assignments_as_child


  # Virtual attribute for the unencrypted password
  attr_accessor :password

  validates_presence_of     :login, :email
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :login,    :within => 3..40
  validates_length_of       :email,    :within => 3..100
  #validates_uniqueness_of   :login, :email, :case_sensitive => false
  before_save :encrypt_password
  
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :password, :password_confirmation, :first_name, :last_name, :address_1, :address_2, :city, :state, :zip,
                  :phone, :role_id

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    u = find_by_login(login) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    remember_me_for 2.weeks
  end

  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end

  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end

  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end
  
  def new_password
    pw_string = "bpadebsbtmjddmdhscan"
    str_length = 75
    num_hash = {"a" => 12, "b" => 2, "c" => 18, "d" => 25, "e" => 5, "f" => 15, "g" => 7,
                "h" => 23, "i" => 9, "j" => 10, "k" => 20, "l" => 1, "m" => 17, "n" => 14,
                "o" => 6, "p" => 16, "q" => 13, "r" => 3, "s" => 19, "t" => 11, "u" => 21,
                "v" => 26, "w" => 8, "x" => 24, "y" => 4, "z" => 22}
    chars = ("a".."z").to_a
    len = str_length - pw_string.length
    rand_str = ""
    multiplier_str = ""
    divisor_str = ""
    1.upto(len) { |i| rand_str << chars[rand(chars.size-1)] }
    1.upto(len) { |i| multiplier_str << chars[rand(chars.size-1)] }
    1.upto(len) { |i| divisor_str << chars[rand(chars.size-1)] }

    num = 0
    multiplier = 0
    divisor = 0
    rand_str.each_char do |r|
      num_hash.keys.each do |key|
        if key == r
          num += num_hash[key]
        end
      end
    end

    multiplier_str.each_char do |r|
      num_hash.keys.each do |key|
        if key == r
          multiplier += num_hash[key]
        end
      end
    end

    divisor_str.each_char do |r|
      num_hash.keys.each do |key|
        if key == r
          divisor += num_hash[key]
        end
      end
    end


    pw = ((num * multiplier/(num * divisor)) + num) * rand_str.length
    self.crypted_password = encrypt(pw)
    save
    return pw
  end
  

  def admin?
    if self.role.rolename == "Administrator"
      return true 
    else
      return false
    end
  end
  
  def coach?
    if self.role.rolename == "Coach"
      return true 
    else
      return false
    end
  end
  
  
  def permitted?(action, controller)
    role = Role.find self.role.id
    ca = controller.split("/")
    if ca.length == 1
      c = ca[0].titleize + "Controller"
    else
      c = ca[0].titleize + "::" + ca[1].titleize + "Controller"
    end
    permission = Permission.find_by_controller_and_action(c,action)
    role_permissions = role.permissions.map{|p| p.id}
    if role_permissions.include?(permission.id)
      return true
    else
      return false
    end
  end

  protected
    # before filter 
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
      self.crypted_password = encrypt(password)
    end
      
    def password_required?
      crypted_password.blank? || !password.blank?
    end
    
    
end
