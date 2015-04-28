class CreateCategorytypes < ActiveRecord::Migration
  def change
    create_table :categorytypes do |t|
      t.string :code
      t.string :name

      t.timestamps
    end
  end
end
