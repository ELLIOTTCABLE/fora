class Post < DataMapper::Base
  property :title, :string
  property :created_at, :datetime
  property :updated_at, :datetime
  
  has_many :post_revisions
  
  # Alias up some more sensible revisions
  alias :revisions :post_revisions; alias :revisions= :post_revisions=
  
  def initialize(*args); super
    revisions << self.class.revision.new
  end
  
  def content=(content); revisions.last.content=(content); end
  def content; revisions.last.content; end
  
  def self.revision; PostRevision; end # Simple alias to PostRevision
end