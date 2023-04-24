class Tag < ActiveRecord::Base
  property :name, :string
  
  validates_uniqueness_of :name
  
  # has_many :posts, :through => :taggings
  has_many :taggings
  has_and_belongs_to_many :posts,
    :join_table => "taggings",
    :left_foreign_key => "tag_id",
    :right_foreign_key => "post_id",
    :class => "Post"
  
  def self.[] name
    tag = first(:name => name)
    if tag.nil?
      tag = new(:name => name)
    end
    tag
  end
  
  def self.parse something
    case something.class.to_s.to_sym
    when :String
      new_tags_names = parse_string(something)
      new_tags = new_tags_names.map {|t| Tag[t]}
    
    when :Array
      case something.first.class.to_s.to_sym # We'll just hope that the elements of the passed-in array are all the same kind.
      when :String
        new_tags_names = something
        new_tags = new_tags_names.map {|t| Tag[t]}
      when :Tag
        new_tags = something
      end
      
    end
    
    output = []
    new_tags.each do |new_tag|
      if new_tag.class == Tag
        output << new_tag
      else
        raise 'TypeError'
      end
    end
    
    output
  end
  
  def self.parse_string string
    string.split(/"(.+?)"|\s+/).reject {|s| s.empty? }
  end
end
