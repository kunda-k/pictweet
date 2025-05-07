class Tweet < ApplicationRecord
  # validates :text, presence: true  ←belongs_toがそのバリデーションをもう持ってるからいらない
  belongs_to :user
  has_many :comments   # commentsテーブルとのアソシエーション
  has_many :favorites, dependent: :destroy # この投稿に対するお気に入りレコード
  # ↓ この投稿をお気に入りしたユーザーを取得しやすくするための設定
  has_many :favoriting_users, through: :favorites, source: :user

  has_one_attached :image 
  enum status: { published: 0, draft: 1 }, _prefix: true


  



  def self.search(search)
    if search != ""
      Tweet.where('text LIKE(?)', "%#{search}%")
    else
      Tweet.all
    end
  end
end
