class Event
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title
  field :url
  field :distance # This should be calculated at runtime
  field :venue_name
  field :address
  field :start_date
  field :logo
  field :source
  field :coordinates, type: Array

  belongs_to :raw
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  attr_accessible :title, :url, :distance, :venue_name, :address, :start_date, :logo, :source, :coordinates

  index({ coordinates: "2d" }, { min: -200, max: 200 })
end
