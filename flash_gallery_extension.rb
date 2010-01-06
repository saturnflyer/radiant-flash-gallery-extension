# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class FlashGalleryExtension < Radiant::Extension
  cattr_accessor :gallery_path

  version "0.3"
  description "Create and manage Flash image/media galleries with SlideShowPro" 
  url "http://github.com/zapnap/radiant-flash-gallery-extension"
  
  extension_config do |config|
    config.gem 'paperclip', :version => '>=2.1.5'
    config.gem 'acts_as_list', :version => '>=0.1.2'
  end
  
  define_routes do |map|
    map.namespace 'admin' do |admin|
      admin.resources :galleries, :collection => { :publish => :get } do |gallery|
        gallery.resources :items, :controller => :gallery_items, 
          :member => { :move_higher => :post, :move_lower => :post, :move_to_top => :post, :move_to_bottom => :post }
      end
    end
  end
  
  def activate
    Radiant::Config['flash_gallery.path'] ||= '/galleries'
    self.gallery_path = Radiant::Config['flash_gallery.path']
    admin.tabs.add "Galleries", "/admin/galleries", :after => "Layouts"
    Page.send :include, FlashGalleryTags
  end
  
  def deactivate
  end
end
