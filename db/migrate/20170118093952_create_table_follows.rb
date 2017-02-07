class CreateTableFollows < ActiveRecord::Migration[5.0]
  def self.up
    create_table :follows do |t|
      t.column :user_id, :integer
      t.column :followable_id, :integer
      t.column :followable_type, :string
      t.timestamps
    end
  end

  def self.down
    drop_table :follows
  end
end
