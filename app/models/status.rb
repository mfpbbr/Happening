class Status
  include Mongoid::Document
  include Mongoid::Timestamps

  field :text, type: String
  field :coordinates, type: Array

  embedded_in :user

  attr_accessible :text, :coordinates

end
