class Share < ActiveRecord::Base
  belongs_to :category
  belongs_to :user

  validates :user_id, presence: true
  validates :category_id, presence: true
end
