class AddAudioToGalleries < ActiveRecord::Migration
  def self.up
    add_column :galleries, :audio_file_name, :string
    add_column :galleries, :audio_content_type, :string
    add_column :galleries, :audio_file_size, :integer
    add_column :galleries, :audio_updated_at, :datetime
  end

  def self.down
    remove_column :galleries, :audio_updated_at
    remove_column :galleries, :audio_file_size
    remove_column :galleries, :audio_content_type
    remove_column :galleries, :audio_file_name
  end
end
