class User < ActiveRecord::Base
  has_many :categories
  has_many :shares

  validates :first_name, presence: true, length: {minimum: 2}
  validates :last_name, presence: true, length: {minimum: 2}
  validates :email, presence: true, uniqueness: true, length: {in: 2..100}
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates :password_hash, presence: true

  def connections
    self.shares.map { |share| share.category }.uniq
  end
end