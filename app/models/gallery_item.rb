class GalleryItem < ActiveRecord::Base
  belongs_to :gallery

  acts_as_list :scope => :gallery_id
  has_attached_file :asset,
    :path => ":rails_root/public#{Radiant::Config['flash_gallery.path']}/containers/gallery_items/:id/:style/:basename.:extension",
    :url  => "#{Radiant::Config['flash_gallery.path']}/containers/gallery_items/:id/:style/:basename.:extension"
    
  attr_protected :asset_file_name, :asset_content_type, :asset_size

  validates_presence_of :gallery
  validates_attachment_presence :asset
  #validates_attachment_content_type :asset, :content_type => ['image/jpeg', 'image/png', 'image/gif', 'image/jpg']
  validates_numericality_of :pause, :allow_blank => true, :only_integer => true

  before_save :set_position
  after_save :publish
  after_destroy :publish

  private

  def set_position
    self.position = (GalleryItem.maximum(:position) || 0) + 1 if position.nil?
  end

  def publish
    gallery.publish
  end
end
