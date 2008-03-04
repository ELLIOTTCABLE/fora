require File.join( File.dirname(__FILE__), "..", "spec_helper" )

shared_examples_for 'a tag parser' do
  before(:each) do
    @tags = []
    ['tag1', 'tag2', 'tag phrase', 'tag3'].each do |tag|
      Tag[tag].save
      @tags << Tag[tag]
    end
  end
  
  it "should be parseable from a string" do
    Tag.parse('tag1 tag2 "tag phrase" tag3').should == @tags
  end
  it "should be parseable from an array of strings" do
    Tag.parse(['tag1', 'tag2', 'tag phrase', 'tag3']).should == @tags
  end
  it "should be parseable from an array of Tags" do # Is this redundant, and/or even worth doing?
    Tag.parse(@tags).should == @tags
  end
end

describe Tag do
  it_should_behave_like 'a tag parser'
  
  
end