class AddPublishedToPublications < ActiveRecord::Migration
  def change
    add_column :publications, :published, :string
    add_column :publications, :description, :string
  end
end
