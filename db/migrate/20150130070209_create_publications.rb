class CreatePublications < ActiveRecord::Migration
  def change
    create_table :publications do |t|
      t.string :title

      t.timestamps
    end
  end
end
