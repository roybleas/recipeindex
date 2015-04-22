class CreateIssuemonths < ActiveRecord::Migration
  def change
    create_table :issuemonths do |t|
      t.integer :monthindex
      t.references :issuedescription, index: true

      t.timestamps
    end
  end
end
