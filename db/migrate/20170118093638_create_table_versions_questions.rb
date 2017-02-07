class CreateTableVersionsQuestions < ActiveRecord::Migration[5.0]
  def change
    create_table :version_questions do |t|
      t.column :title, :string
      t.column :content, :string
      t.column :user_id, :integer
      t.column :question_target, :integer
      t.column :version, :integer
      t.column :status, :integer
      t.timestamps
    end
  end
end
