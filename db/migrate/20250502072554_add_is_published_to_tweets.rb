class AddIsPublishedToTweets < ActiveRecord::Migration[7.1]
  def change
    add_column :tweets, :is_published, :boolean
  end
end
