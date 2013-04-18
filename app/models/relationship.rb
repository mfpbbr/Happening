class Relationship
  include Mongoid::Document
  include Mongoid::Timestamps

  field :follower_id, type: Integer
  field :followed_id, type: Integer

  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

  attr_accessible :followed_id

  validates :follower_id, presence: true
  validates :followed_id, presence: true

  index({ follower_id: 1})
  index({ followed_id: 1})
  index({ follower_id: 1, followed_id: 1}, { unique: true })
end
