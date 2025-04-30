class Comment < ApplicationRecord

  belongs_to :tweet #Tweetテーブルとのアソシエーション
  belongs_to :user  #Userテーブルとのアソシエーション

end
