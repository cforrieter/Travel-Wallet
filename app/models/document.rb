class Document < ActiveRecord::Base
  belongs_to :category
  mount_uploader :file, Uploader   
end
