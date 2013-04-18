class Status
  include Mongoid::Document
  include Mongoid::Timestamps

  field :text, type: String
  field :coordinates, type: Array

  belongs_to :user
  has_many :likes, as: :likeable, dependent: :destroy

  attr_accessible :text, :coordinates

  def title
    self.text
  end
end
