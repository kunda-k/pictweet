class TweetsController < ApplicationController

  before_action :set_tweet, only: [:edit, :show]
  before_action :move_to_index, except: [:index, :show, :search]
  def index
    # ★ログ出力（Pagy適用前）
    base_tweets = Tweet.includes(:user).order("created_at DESC")

    @pagy, @tweets = pagy(base_tweets, items: 3)

  end

  def new
    @tweet = Tweet.new
  end

  def create
    
    Tweet.create(tweet_params)
    redirect_to '/'
  end

  def destroy
    tweet = Tweet.find(params[:id])
    tweet.destroy
    redirect_to root_path
  end

  def edit
  end

  def update
    tweet = Tweet.find(params[:id])
    tweet.update(tweet_params)
    redirect_to root_path #13行目redirect_to '/'と同じ意味
  end

  def show
    @comment = Comment.new
    @comments = @tweet.comments.includes(:user).order("created_at DESC")
  end

  def search
    @tweets = Tweet.search(params[:keyword]).order("created_at DESC")
    
  end

  # ↓ お気に入り一覧表示用のアクションを追加
  def favorites
    # Userモデルに has_many :favorite_tweets, through: :favorites, source: :tweet が定義されている前提
    @favorite_tweets = current_user.favorite_tweets.includes(:user).order("created_at DESC")
    
    # ↑ 変数名を @tweets ではなく @favorite_tweets にすると、indexアクションと区別しやすい（任意）

    # Kaminariなどのページネーションを使う場合
    # @favorite_tweets = @favorite_tweets.page(params[:page])

    # このアクションが実行されると、Railsは自動的に
    # app/views/tweets/favorites.html.erb を探しに行く
  end


  private
  def tweet_params
    params.require(:tweet).permit(:image, :text).merge(user_id: current_user.id)
  end
  
  def set_tweet
    @tweet = Tweet.find(params[:id])
end

  def move_to_index
    unless user_signed_in?
      redirect_to action: :index
    end
  end
end