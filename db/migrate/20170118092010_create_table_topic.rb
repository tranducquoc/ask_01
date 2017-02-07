class CreateTableTopic < ActiveRecord::Migration[5.0]
  def self.up
    create_table :topics do |t|
      t.column :name, :string
      t.column :description, :string
      t.column :icon, :string, :limit => 255
      t.column :slug, :string
      t.timestamps
    end
  end

  def self.down
    drop_table :topics
  end
end
