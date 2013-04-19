class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :text

  belongs_to :user
  belongs_to :commentable, polymorphic: true
  has_many :likes, as: :likeable, dependent: :destroy

  attr_accessible :text

  validates :user_id, presence: true
  validates :text, presence: true
  validates :commentable_id, presence: true
  validates :commentable_type, presence: true

  index({ user_id: 1, commentable_id: 1, commentable_type: 1 })

  def title
    return self.text
  end
end
