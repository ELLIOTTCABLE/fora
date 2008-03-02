class Posts < Application
  # provides :xml, :yaml, :js
  
  def index
    @posts = Post.all
    display @posts
  end

  def show
    @post = Post.first(params[:id])
    raise NotFound unless @post
    display @post
  end

  def new
    only_provides :html
    @post = Post.new
    render
  end

  def edit
    only_provides :html
    @post = Post.first(params[:id])
    raise NotFound unless @post
    render
  end

  def create
    @post = Post.new(params[:post])
    if @post.save
      redirect url(:post, @post)
    else
      render :new
    end
  end

  def update
    @post = Post.first(params[:id])
    raise NotFound unless @post
    if @post.update_attributes(params[:post])
      redirect url(:post, @post)
    else
      raise BadRequest
    end
  end

  def destroy
    @post = Post.first(params[:id])
    raise NotFound unless @post
    if @post.destroy!
      redirect url(:posts)
    else
      raise BadRequest
    end
  end
  
end
