class CreateIssueyears < ActiveRecord::Migration
  def change
    create_table :issueyears do |t|
      t.integer :year
      t.references :publication, index: true

      t.timestamps
    end
  end
end
