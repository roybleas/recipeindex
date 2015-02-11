class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.string :title
      t.references :publication, index: true
      t.references :issueyear, index: true
      t.references :issuedescription, index: true

      t.timestamps
    end
  end
end
