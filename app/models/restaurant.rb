class Restaurant
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title
  field :url
  field :distance # This should be calculated at runtime
  field :address
  field :category_list
  field :review_count
  field :rating_image_url
  field :image_url
  field :source
  field :coordinates, type: Array

  belongs_to :raw
  has_many :likes, as: :likeable, dependent: :destroy

  attr_accessible :title, :url, :distance, :address, :category_list, :review_count, :rating_image_url, :image_url, :source, :coordinates

  index({ coordinates: "2d" }, { min: -200, max: 200 })
end
