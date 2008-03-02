class Post < DataMapper::Base
  property :title, :string
  property :created_at, :datetime
  property :updated_at, :datetime
  
  has_many :post_revisions
end