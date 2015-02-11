class CreateIssuedescriptions < ActiveRecord::Migration
  def change
    create_table :issuedescriptions do |t|
      t.string :title
      t.string :full_title
      t.integer :seq
      t.references :publication, index: true

      t.timestamps
    end
  end
end
