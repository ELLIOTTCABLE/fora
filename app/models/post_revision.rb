class PostRevision < DataMapper::Base
  property :content, :text
  property :created_at, :datetime
  
  belongs_to :post
end