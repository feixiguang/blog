class PostsController < ApplicationController

  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_post_and_check_permission, only: [:edit, :update, :destroy]

  def index
    @posts = Post.all.order('created_at DESC')
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user
    if @post.save
      redirect_to @post
    else
      render :new
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: "Update Success"
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to root_path, alert: "Post deleted"
  end

  private

  def find_post_and_check_permission
    @post = Post.find(params[:id])

    if current_user != @post.user
      redirect_to root_path, alert: "You have no permission."
    end
  end

  def post_params
    params.require(:post).permit(:title, :body)
  end

end
