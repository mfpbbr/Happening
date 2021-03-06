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
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  attr_accessible :title, :url, :distance, :merchant_name, :address, :source, :coordinates, :image_small, :image_large

  index({ coordinates: "2d" }, { min: -200, max: 200 })
  index({ url: 1 })
  index({ created_at: -1 })
end
