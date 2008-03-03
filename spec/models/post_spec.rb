require File.join( File.dirname(__FILE__), "..", "spec_helper" )

describe Post do
  before(:each) do
    @post = Post.new
    @post.save
  end
  
  it "should have a title" do
    @post.title = 'Yay!'
    @post.title.should == 'Yay!'
  end
  it "should have content" do
    @post.content = 'Hi, my name is George.'
    @post.content.should == 'Hi, my name is George.'
  end
  
  it "should have at least one revision" do
    @post.revisions.size.should >= 1
  end
  it "should proxy to last revision for content" do
    @post.content.should eql(@post.revisions.last.content)
    @post.content = 'something else'
    @post.content.should eql(@post.revisions.last.content)
  end
  
end