class CreateTableUser < ActiveRecord::Migration[5.0]

  def self.up
    create_table :users do |t|
      t.column :name, :string
      t.column :avatar, :string
      t.column :story, :string
      t.column :slug, :string
      t.column :role, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end

end
