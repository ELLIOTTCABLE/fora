require 'rubygems'
require 'ramaze'

require 'data.rb'

require 'enumerator'; module Enumerable
  def inject_with_index(*args, &block); enum_for(:each_with_index).inject(*args, &block); end
end

class StyleController < Ramaze::Controller
  template_root :templates
  engine :Sass
  map '/style'
end

class MainController < Ramaze::Controller
  template_root :templates
  engine :Haml
  layout :layout => [:topics, :topic, :test]

  def topics
    topics = Post.all.inject({}) do |acc, post|
      post.tags.split("\n").each do |topic|
        acc.key?(topic) ? acc[topic] += 1 : acc[topic] = 1
      end
      acc
    end
    
    topics = topics.map do |topic|
      topic[0] = topic[0].gsub(/^/,'&ldquo;').gsub(/$/,'&rdquo;') if topic[0].match(/[^A-Za-z0-9\-_.]/)
      topic
    end
    @topics = topics.sort{|a,b| a[1]<=>b[1]}.reverse
  end
  
  def topic topic
    @topic = topic
    @posts = Post.all.reject{|p| !p.tags.include? topic }.reject{|p| p.post_id != nil }
  end
end

Ramaze.start :adapter => :thin, :load_engines => [:Haml, :Sass]