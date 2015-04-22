class AddYearToIssues < ActiveRecord::Migration
  def change
    add_column :issues, :year, :integer
    remove_column :issues, :yr, :integer
  end
end

