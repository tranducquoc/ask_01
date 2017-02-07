class CreateTableQuestionUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :question_users do |t|
      t.column :question_id, :integer
      t.column :user_id, :integer
      t.timestamps
    end
  end
end
