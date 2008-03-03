require File.join( File.dirname(__FILE__), "..", "spec_helper" )

describe PostRevision do
  before(:each) do
    @post = Post.new
    @post.save
    @revision = @post.revisions.first
  end
  
  it "should not have modifable content" do
    @revision.content = 'foobar'
    @revision.content.should_not == 'foobar'
  end
  it "should create a new revision if you attempt to modify the content" do
    @revision.content = 'foobar'
    @revision.post.revisions.size.should == 2
  end
  it "should create a new revision with the content if you attempt to modify the content" do
    @revision.content = 'foobar'
    @revision.post.revisions.last.content.should == 'foobar'
  end
  # TODO: Clean this spec up, it's confusing
  it "should save with the post" do
    post = @revision.post
    @revision = @revision.class.new
    post.revisions << @revision
    @revision.new_record?.should be_true
    post.save
    @revision.new_record?.should be_false
  end
end