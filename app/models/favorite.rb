class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :tweet
  
   # user_idとtweet_idの組み合わせのユニーク性をモデルレベルでも検証 (任意)
   validates :user_id, uniqueness: { scope: :tweet_id } # scope: :pict_id に変更

end
