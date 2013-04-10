class Landmark
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title
  field :url
  field :distance # This should be calculated at runtime
  field :source
  field :coordinates, type: Array

  belongs_to :raw

  attr_accessible :title, :url, :distance, :source, :coordinates

  index({ location: "2d" }, { min: -200, max: 200 })
end
