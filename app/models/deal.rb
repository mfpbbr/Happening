class Deal
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title
  field :url
  field :distance # This should be calculated at runtime
  field :merchant_name
  field :address # This is nullable
  field :source
  field :coordinates, type: Array
  field :image_small
  field :image_large

  belongs_to :raw

  attr_accessible :title, :url, :distance, :merchant_name, :address, :source, :coordinates, :image_small, :image_large

  index({ coordinates: "2d" }, { min: -200, max: 200 })
end
