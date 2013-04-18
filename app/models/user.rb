class User
  include Mongoid::Document
  include Mongoid::Timestamps

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, 
         authentication_keys: [:login]

  ## Database authenticatable
  field :email,              :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""
  
  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  field :username
  field :_id, type: String, default: ->{ username }
  validates :username, presence: true, uniqueness: { case_sensitive: false }
  # DEVISE AUTOMATICALLY VALIDATES THE EMAIL AND PASSWORD FIELDS
  VALID_EMAIL_REGEX = /^[\w+\-.]+@[a-z\d\-.]+\.[a-z]+$/i
  validates :email, presence: true, uniqueness: { case_sensitive: false },
                  format: { with: VALID_EMAIL_REGEX }
  attr_accessible :username, :email, :password, :password_confirmation, :remember_me

  attr_accessor :login
  attr_accessible :login

  has_many :statuses, dependent: :destroy
  has_many :likes, dependent: :destroy

  index({ "statuses.coordinates" => "2d" }, { min: -200, max: 200 })

  def activity
    activity_items = []
    # each activity item should consist of:
    # 1) username
    # 2) action: liked, posted status update, commented on
    # 3) entity_title
    # 4) entity_url
    # 5) action_created_timestamp

    statuses.each do |status|
      activity_item = {}
      activity_item[:username] = status.user.username
      activity_item[:action] = "posted status update"
      activity_item[:entity_title] = status.text
      activity_item[:entity_url] = status
      activity_item[:action_created_at] = status.created_at

      activity_items << activity_item
    end

    likes.each do |like|
      activity_item = {}
      activity_item[:username] = like.user.username
      activity_item[:action] = "liked " + like.likeable.class.to_s
      activity_item[:entity_title] = like.likeable.title
      activity_item[:entity_url] = like.likeable
      activity_item[:action_created_at] = like.created_at
  
      activity_items << activity_item
    end

    activity_items.sort_by! { |activity_item| activity_item[:action_created_at] }.reverse!

    activity_items
  end

  def feed
    activity
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login).downcase
      where(conditions).where('$or' => [ { username: /^#{Regexp.escape(login)}$/i }, { email: /^#{Regexp.escape(login)}$/i } ]).first
    else
      where(conditions).first
    end
  end

  ## Confirmable
  # field :confirmation_token,   :type => String
  # field :confirmed_at,         :type => Time
  # field :confirmation_sent_at, :type => Time
  # field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,       :type => Time

  ## Token authenticatable
  # field :authentication_token, :type => String
end
