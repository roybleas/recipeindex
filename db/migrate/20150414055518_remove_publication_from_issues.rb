class RemovePublicationFromIssues < ActiveRecord::Migration
  def change
    remove_reference :issues, :publication, index: true
    remove_reference :issues, :issueyear, index: true
  end
end
