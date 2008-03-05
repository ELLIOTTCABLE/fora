class PostRevision < DataMapper::Base
  property :content, :text, :lazy => false
  property :created_at, :datetime
  
  belongs_to :post
  validates_presence_of :post
  validates_presence_of :content
  
  def content=(content)
    if new_record?
      @content = content
    else
      r = self.class.new(:content => content)
      post.revisions << r
      content # return
    end
  end
  
  def title; post.title; end
end