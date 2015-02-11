class AddNoToIssues < ActiveRecord::Migration
  def change
    add_column :issues, :no, :integer
  end
end
