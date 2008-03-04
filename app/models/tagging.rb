class Tagging < DataMapper::Base
  belongs_to :tag
  belongs_to :post
end