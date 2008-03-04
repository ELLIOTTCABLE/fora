require File.join( File.dirname(__FILE__), "..", "spec_helper" )

shared_examples_for 'a taggable post' do
  before(:each) do
    @post = Post.new
  end
  it "should be taggable" do
    @post.tag 'tag1 tag2 "tag phrase"'
    @post.save
    @post.tags.entries.should == Tag.parse('tag1 tag2 "tag phrase"')
  end
  
  it "should be filterable by tag" do
    some_tags = ['something', 'something else', 'a third something']
    @post.tag some_tags
    @post.save
    Post.all_by_tags some_tags
  end
end

describe Post do
  it_should_behave_like 'a taggable post'
  
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