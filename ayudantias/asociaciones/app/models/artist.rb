class Artist < ApplicationRecord
  belongs_to :user
  has_many :albums
end
