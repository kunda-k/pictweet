class CommentsController < ApplicationController
# destroyアクションの前に @comment をセットする (任意だが推奨)
before_action :set_comment, only: [:destroy]
# destroyアクションの前に権限チェックを行う (任意だが推奨)
before_action :authorize_user!, only: [:destroy]

  def create
    comment = Comment.create(comment_params)
    redirect_to "/tweets/#{comment.tweet.id}"  # コメントと結びつくツイートの詳細画面に遷移する
  end


  def destroy
    # @comment は before_action :set_comment でセットされる
    @tweet = @comment.tweet # コメントからツイートを取得

    @comment.destroy
    # redirect_to tweet_path(@tweet), notice: 'コメントを削除しました。'
    # Turbo利用時は status: :see_other をつけるのが推奨される
    redirect_to tweet_path(@tweet), notice: 'コメントを削除しました。', status: :see_other
  end


  private
  def comment_params
    params.require(:comment).permit(:text).merge(user_id: current_user.id, tweet_id: params[:tweet_id])
  end

  def set_comment
    # パラメータから削除対象のコメントIDを取得してインスタンス変数へ
    # 通常、ネストした destroy ルートではコメントのIDは :id として渡される
    @comment = Comment.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: 'コメントが見つかりません。' # 見つからない場合のエラー処理
  end

  def authorize_user!
    # @comment は set_comment でセットされている前提
    # ログインユーザーがコメントの投稿者でない場合はリダイレクト
    unless @comment.user_id == current_user.id
      redirect_to tweet_path(@comment.tweet), alert: '自分のコメント以外は削除できません。'
    end
  end

end
