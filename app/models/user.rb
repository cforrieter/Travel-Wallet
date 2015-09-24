class User < ActiveRecord::Base
  has_many :categories
  has_many :shares
end