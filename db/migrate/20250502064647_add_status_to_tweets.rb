class AddIsPublishedToTweets < ActiveRecord::Migration[7.0] # バージョンは適宜合わせる
  def change
    # デフォルト値を false にし、null を許可しない場合
    add_column :tweets, :is_published, :boolean, default: false, null: false
  end
end