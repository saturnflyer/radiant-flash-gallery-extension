class Admin::GalleriesController < ApplicationController
  helper 'admin/gallery_items'

  def index
    @galleries = Gallery.find(:all, :order => "title")
    render(:action => 'index')
  end

  def new
    @gallery = Gallery.new
    render(:action => 'edit')
  end

  def create
    @gallery = Gallery.new(params[:gallery])
    if @gallery.save
      redirect_to(admin_galleries_path)
    else
      flash[:error] = "Validation errors occurred while processing this form. Please take a moment to review the form and correct any input errors before continuing."
      render(:action => 'edit')
    end
  end

  def show
    @gallery = Gallery.find(params[:id])
    @preview = Page.new.send(:parse, "<r:gallery name='#{@gallery.title}' height='100%' width='100%'/>")
    render(:action => 'preview', :layout => false)
  end

  def edit
    @gallery = Gallery.find(params[:id])
    render(:action => 'edit')
  end

  def update
    @gallery = Gallery.find(params[:id])
    if @gallery.update_attributes(params[:gallery])
      redirect_to(admin_galleries_path)
    else
      flash[:error] = "Validation errors occurred while processing this form. Please take a moment to review the form and correct any input errors before continuing."
      render(:action => 'edit')
    end
  end

  def destroy
    @gallery = Gallery.find(params[:id])
    @gallery.destroy
    redirect_to(admin_galleries_path)
  end

  def publish
    @galleries = Gallery.find(:all)
    @galleries.each { |gallery| gallery.publish }
    flash[:notice] = "The galleries were republished."
    redirect_to(admin_galleries_path)
  end
end
