class ChangeTableTopicAndAnswersAndAddTopicUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :user_topics do |t|
      t.column :user_id, :integer
      t.column :topic_id, :integer
      t.timestamps
    end
  end
end
