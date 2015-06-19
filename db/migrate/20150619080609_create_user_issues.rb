class CreateUserIssues < ActiveRecord::Migration
  def change
    create_table :user_issues do |t|
      t.references :user, index: true
      t.references :issue, index: true

      t.timestamps null: false
    end
    add_foreign_key :user_issues, :users
    add_foreign_key :user_issues, :issues
  end
end
