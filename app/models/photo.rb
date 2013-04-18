class Photo
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title # This is the image caption and it can be null
  field :url
  field :distance # This should be calculated at runtime
  field :location_name # place where the photo was taken - can be null
  field :source
  field :coordinates, type: Array
  field :image_small
  field :image_large

  belongs_to :raw
  has_many :likes, as: :likeable, dependent: :destroy

  attr_accessible :title, :url, :distance, :location_name, :source, :coordinates, :image_small, :image_large

  index({ coordinates: "2d" }, { min: -200, max: 200 })

  def title
    self.image_small
  end
end
