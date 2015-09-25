class Category < ActiveRecord::Base
  belongs_to :user
<<<<<<< HEAD
  has_many :shares
=======
  has_many :documents
>>>>>>> 37e9c4af19237c0017901841e4e46a5cead7c941
end