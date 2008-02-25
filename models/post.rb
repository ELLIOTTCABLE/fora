class Post < Sequel::Model
  set_schema do
    primary_key :id
    text :content
  end
end