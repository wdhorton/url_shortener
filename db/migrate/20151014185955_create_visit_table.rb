class CreateVisitTable < ActiveRecord::Migration
  def change
    create_table :visit_tables do |t|

      t.integer :user_id
      t.integer :url_id

      t.timestamps
    end

    add_index :visit_tables, :user_id
    add_index :visit_tables, :url_id
  end
end
