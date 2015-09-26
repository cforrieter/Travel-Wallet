class Category < ActiveRecord::Base
  belongs_to :user

  has_many :shares
  has_many :documents

  def hash
    self.user_id
  end

  def eql?(other_obj)
    self.user_id == other_obj.user_id
  end
end