class Post < DataMapper::Base
  property :title, :string
  property :created_at, :datetime
  property :updated_at, :datetime
  
  has_many :post_revisions
  
  # Alias up some more sensible revisions
  alias :revisions :post_revisions; alias :revisions= :post_revisions=
  
  after_create :after_create
  
  def after_create
    revisions << self.class.revision.new
  end
  
  def content=(content)
    r = self.class.revision.new
    if r.content=(content)
      revisions << r
      else; raise 'WtfError'
    end
  end
  def content; revisions.last.content; end
  
  
  def self.revision; PostRevision; end # Simple alias to PostRevision
end