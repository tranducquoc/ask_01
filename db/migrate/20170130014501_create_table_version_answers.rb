class CreateTableVersionAnswers < ActiveRecord::Migration[5.0]
  def change
    create_table :version_answers do |t|
      t.column :content, :string
      t.column :answer_target, :integer
      t.column :version, :integer
      t.column :user_id, :integer
      t.column :status, :integer
      t.timestamps
    end
  end
end
