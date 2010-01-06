class AddPauseToGalleryItems < ActiveRecord::Migration
  def self.up
    add_column :gallery_items, :pause, :string
  end

  def self.down
    remove_column :gallery_items, :pause
  end
end
