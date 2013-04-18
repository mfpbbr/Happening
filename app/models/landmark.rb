class Landmark
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title
  field :url
  field :distance # This should be calculated at runtime
  field :source
  field :coordinates, type: Array

  belongs_to :raw
  has_many :likes, as: :likeable, dependent: :destroy

  attr_accessible :title, :url, :distance, :source, :coordinates

  index({ coordinates: "2d" }, { min: -200, max: 200 })
end
