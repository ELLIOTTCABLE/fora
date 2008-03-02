require File.join( File.dirname(__FILE__), "..", "spec_helper" )

describe Post do
  before(:each) do
    @post = Post.new
    @post.save
  end
  
  it "should have at least one revision" do
    @post.revisions.size.should >= 1
  end

  it "should proxy to last revision for content" do
    last_revision = @post.revisions.last
    @post.content.should eql(last_revision.content)
  end

end