class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :tweets, dependent: :destroy
  has_many :comments  # commentsテーブルとのアソシエーション
  has_many :favorites, dependent: :destroy # ユーザーがお気に入りしたレコード
  # ↓ ユーザーがお気に入りした投稿を取得しやすくするための設定
  has_many :favorite_tweets, through: :favorites, source: :tweet # source: :pict に変更

  # ある投稿をお気に入り済みか判定するメソッド (任意ですが便利)
  def favorite?(tweet) # favorite?(pict) に変更
    self.favorite_tweets.include?(tweet) # self.favorite_picts.include?(pict) に変更
  end
end
