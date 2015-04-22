class DropIssueyear < ActiveRecord::Migration
  def up
    drop_table :issueyears
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
