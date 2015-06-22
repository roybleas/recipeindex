class CreateUserIssues < ActiveRecord::Migration
  def change
    create_table :user_issues do |t|
      t.references :user
      t.references :issue

      t.timestamps null: false
    end
    add_index(:user_issues, [:user_id, :issue_id], unique: true)
    add_foreign_key :user_issues, :users
    add_foreign_key :user_issues, :issues
  end
end
