class AddTargetToGalleryItems < ActiveRecord::Migration
  def self.up
    add_column :gallery_items, :target, :string
  end

  def self.down
    remove_column :gallery_items, :target
  end
end
