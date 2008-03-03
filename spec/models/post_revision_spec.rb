require File.join( File.dirname(__FILE__), "..", "spec_helper" )

shared_examples_for 'a lonely revision' do
  before(:each) do
    @revision = PostRevision.new
  end
  
  it "should not be saveable without an associated post" do
    (@revision.save).should be_false
  end
end

shared_examples_for 'a revision with auto-proxied content' do
  before(:each) do
    post = Post.new
    @revision = post.revisions.last
    @revision.save
  end
  
  it "should not have modifable content when saved" do
    @revision.content = 'foobar'
    @revision.content.should_not == 'foobar'
  end
  it "should create a new revision if you attempt to modify the content after saving" do
    @revision.content = 'foobar'
    @revision.post.revisions.size.should == 2
  end
  it "should create a new revision with the content if you attempt to modify the content" do
    @revision.content = 'foobar'
    @revision.post.revisions.last.should_not == @revision
    @revision.post.revisions.last.content.should == 'foobar'
  end
end

shared_examples_for 'a taggable revision' do
  it "should be taggable"
end

describe PostRevision do
  it_should_behave_like 'a lonely revision'
  it_should_behave_like 'a revision with auto-proxied content'
  it_should_behave_like 'a taggable revision'
  
  # TODO: Clean this spec up, it's confusing
  it "should save with the post" do
    post = @revision.post
    new_revision = @revision.class.new
    post.revisions << new_revision
    
    new_revision.new_record?.should be_true
    post.save
    new_revision.new_record?.should be_false
  end
end