class AddAudioCaptionToGalleries < ActiveRecord::Migration
  def self.up
    add_column :galleries, :audio_caption, :string
  end

  def self.down
    remove_column :galleries, :audio_caption
  end
end
