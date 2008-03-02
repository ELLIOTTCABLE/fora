class Post < DataMapper::Base
  property :updated_at, :datetime
  property :title, :string
  property :content, :text
  property :created_at, :datetime
end