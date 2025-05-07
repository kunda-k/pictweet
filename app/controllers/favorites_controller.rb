class FavoritesController < ApplicationController
 
before_action :set_tweet, only: [:create, :destroy] # この行を確認

  def create
    Rails.logger.debug "===== Entering create action. @tweet is: #{@tweet.inspect} ====="
    @favorite = current_user.favorites.build(tweet_id: @tweet.id)

    respond_to do |format|
      if @favorite.save
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            helpers.dom_id(@tweet, :favorite_button), # <= helpers. を追加
            partial: 'favorites/favorite_button',
            locals: { tweet: @tweet }
          )
        end
        format.html { redirect_back(fallback_location: root_path) }
      else
        format.html { redirect_back(fallback_location: root_path, alert: 'お気に入り登録に失敗しました。') }
        format.turbo_stream { head :unprocessable_entity }
      end
    end
  end

  def destroy
    @favorite = current_user.favorites.find_by(tweet_id: @tweet.id)

    respond_to do |format|
      if @favorite&.destroy
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            helpers.dom_id(@tweet, :favorite_button), # <= helpers. を追加
            partial: 'favorites/favorite_button',
            locals: { tweet: @tweet }
          )
        end
        format.html { redirect_back(fallback_location: root_path) }
      else
        format.html { redirect_back(fallback_location: root_path, alert: 'お気に入り解除に失敗しました。') }
        format.turbo_stream { head :unprocessable_entity }
      end
    end
  end

  private

  def set_tweet
    param_key = :tweet_id # または :pict_id など、実際のキーに合わせる
    model_name = Tweet   # または Pict など、実際のモデル名に合わせる
  
    # ↓ 受け取ったパラメータをログに出力
    Rails.logger.debug "===== In set_tweet. Params are: #{params.inspect} ====="
    Rails.logger.debug "===== In set_tweet. Trying to find with ID: #{params[param_key]} ====="
  
    @tweet = model_name.find(params[param_key])
  
    # ↓ findが成功した場合の@tweetをログに出力
    Rails.logger.debug "===== In set_tweet. Found tweet: #{@tweet.inspect} ====="
  
  rescue ActiveRecord::RecordNotFound
    # ↓ rescueブロックに入ったことをログに出力
    Rails.logger.debug "===== In set_tweet rescue block. RecordNotFound for ID: #{params[param_key]} ====="
    redirect_to root_path, alert: "指定された投稿が見つかりません。"
    return
  end
end