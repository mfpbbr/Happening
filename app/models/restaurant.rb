class Restaurant
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title
  field :url
  field :distance # This should be calculated at runtime
  field :address
  field :source
  field :coordinates, type: Array

  belongs_to :raw

  attr_accessible :title, :url, :distance, :address, :source, :coordinates

  index({ coordinates: "2d" }, { min: -200, max: 200 })
end
