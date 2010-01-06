class Gallery < ActiveRecord::Base
  has_many :gallery_items
  has_attached_file :swf, 
    :path => ":rails_root/public#{Radiant::Config['flash_gallery.path']}/containers/:id/:style/:basename.:extension",
    :url  => "#{Radiant::Config['flash_gallery.path']}/containers/:id/:style/:basename.:extension"
  has_attached_file :audio, 
    :path => ":rails_root/public#{Radiant::Config['flash_gallery.path']}/containers/:id/:style/:basename.:extension",
    :url  => "#{Radiant::Config['flash_gallery.path']}/containers/:id/:style/:basename.:extension"

  validates_presence_of :title
  validates_uniqueness_of :title
  validates_attachment_presence :swf
  validates_attachment_content_type :swf, :content_type => 'application/x-shockwave-flash'
  validates_attachment_size :audio, :less_than => 5.megabytes

  before_validation_on_create :generate_file_name
  after_save :publish
  after_destroy :unpublish

  def to_xml
    out = "<?xml version='1.0' encoding='UTF-8'?><gallery>"
    out += "<album lgPath='' tnPath='' title='#{title}' description='#{description}' tn=''"
    out += " audio='#{audio.url}' audioCaption=''" if audio
    out += ">"

    gallery_items.find(:all, :order => 'position, created_at').each do |item|
      out += "<img src='#{item.asset.url}' title='#{item.title}' caption='#{item.caption}' "
      out += "link='#{item.link}' target='#{item.target}' " unless item.link.blank?
      out += "pause='#{item.pause}' " unless item.pause.blank?
      out += "/>"
    end

    out += "</album></gallery>"
  end

  # write the file to the specified disk location
  def publish
    File.open(full_xml_file_path, 'w') do |f|
      f.write self.to_xml
    end
  end

  private

  def unpublish
    File.delete(full_xml_file_path) if File.exists?(full_xml_file_path)
  end

  def gallery_path
    "#{FlashGalleryExtension.gallery_path}/#{(title || '').to_slug}"
  end

  def full_gallery_path
    "#{RAILS_ROOT}/public#{gallery_path}"
  end

  def full_xml_file_path
    "#{RAILS_ROOT}/public#{xml_file_name}"
  end

  def generate_file_name
    self.xml_file_name = "#{gallery_path}.xml" unless title.nil?
  end
end
