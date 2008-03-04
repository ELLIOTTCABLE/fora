class Post < DataMapper::Base
  property :title, :string
  property :created_at, :datetime
  property :updated_at, :datetime
  
  has_many :post_revisions
  
  # has_many :posts, :through => :taggings
  has_many :taggings
  has_and_belongs_to_many :tags,
    :join_table => "taggings",
    :left_foreign_key => "post_id",
    :right_foreign_key => "tag_id",
    :class => "Tag"
  
  # Alias up some more sensible revisions
  alias :revisions :post_revisions; alias :revisions= :post_revisions=
  
  def initialize(*args); super
    revisions << self.class.revision.new
  end
  
  def content=(content); revisions.last.content=(content); end
  def content; revisions.last.content; end
  
  def self.revision; PostRevision; end # Simple alias to PostRevision
  
  # TODO: This seems dirty, refactor
  def tag input
    Tag.parse(input).each do |new_tag|
      tags << new_tag
    end
  end
  
  def tag_names
    tags.map do |tag|
      name = tag.name
      name.match(' ') ? "\"#{name}\"" : name
    end.join(' ')
  end
  
  ## TODO: There has *got* to be another way to do this. It's ridiculous. Also, refactor.
  def self.all_by_tags input
    the_tags = Tag.parse(input)
    
    post_ids = []
    the_tags.each do |tag|
      post_ids << Tagging.all(:tag_id => tag.id).map(&:post_id)
    end
    
    common_ids = post_ids.inject {|r, ids| r & ids}
    
    common_ids.empty? ? [] : Post.all(:id => common_ids) 
  end
end