class CreateTableAnswers < ActiveRecord::Migration[5.0]
  def change
    create_table :answers do |t|
      t.column :content, :string
      t.column :reply_to, :integer
      t.column :user_id, :integer
      t.column :up_vote, :integer
      t.column :down_vote, :integer
      t.timestamps
    end
  end
end
