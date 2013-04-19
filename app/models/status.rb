class Status
  include Mongoid::Document
  include Mongoid::Timestamps

  field :text, type: String
  field :coordinates, type: Array

  belongs_to :user
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  attr_accessible :text, :coordinates

  index({ coordinates: "2d" }, { min: -200, max: 200 })

  def title
    self.text
  end
end
