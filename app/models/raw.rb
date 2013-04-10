class Raw
  include Mongoid::Document
  include Mongoid::Timestamps

  field :data, type: Hash
  field :source_url, type: String

  has_many :landmarks, dependent: :destroy

  attr_accessible :data, :source_url
end
