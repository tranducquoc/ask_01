class CreateTableActions < ActiveRecord::Migration[5.0]
  def change
    create_table :actions do |t|
      t.column :user_id, :integer
      t.column :actionable_id, :integer
      t.column :actionable_type, :string
      t.column :type_act, :integer
    end
  end
end
