class AdminUser < ApplicationRecord

  #self.table_name = "admin_users"

  has_secure_password

  has_and_belongs_to_many :pages

  has_many :section_edits
  has_many :sections, :through => :section_edits

  scope :sorted, lambda { order("last_name ASC, first_name ASC") }

  EMAIL_REGEX = /\A[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}\Z/i
  FORBIDDEN_USERNAMES = ['littlebopeep', 'humptydumpty', 'marymary']

  def name
    "#{first_name} #{last_name}"
  end

  # Long form validation
  # validates_presence_of :first_name
  # validates_length_of :first_name, :within => 2..30
  # validates_presence_of :last_name
  # validates_length_of :last_name, :within => 2..50
  # validates_presence_of :username
  # validates_length_of :username, :within => 4..25
  # validates_uniqueness_of :username
  # validates_presence_of :email
  # validates_length_of :email, :maximum => 100
  # validates_format_of :email, :within => EMAIL_REGEX
  # validates_confirmation_of :email

  # Sexy validation
  validates :first_name, :presence => true,
                         :length => {:within => 2..30}
  validates :last_name, :presence => true,
                        :length => {:within => 2..50}
  validates :username, :uniqueness => true,
                       :length => {:within => 4..25},
                       :presence => true
  validates :email, :presence => true,
                    :length => {:maximum => 100},
                    :format => EMAIL_REGEX,
                    :confirmation => true

  validate :username_is_allowed
  validate :no_new_user_on_tuesday, :on => :create

  private

  def username_is_allowed
    if FORBIDDEN_USERNAMES.include?(username)
      errors.add(:username, "has been restricted from use.")
    end
  end

  def no_new_user_on_tuesday
    if Time.now.wday == 2
      errors.add(:base, "No new users on Tuesdays.")
    end
  end

end