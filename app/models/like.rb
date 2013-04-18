class Like
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  belongs_to :likeable, polymorphic: true

  validates :user_id, presence: true
  validates :likeable_id, presence: true
  validates :likeable_type, presence: true

  index({ user_id: 1, likeable_id: 1, likeable_type: 1 }, { unique: true })
end
