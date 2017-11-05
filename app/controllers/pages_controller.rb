class PagesController < ApplicationController

  layout 'admin'

  before_action :confirm_logged_in
  before_action :find_subject
  before_action :set_page_count, :only => [:new, :create,:edit, :update]

  def index
    @pages = @subject.pages.sorted
  end

  def show
    # Instantiate object
    @page = Page.find(params[:id])
  end

  def new
    @page = Page.new(:subject_id => @subject.id)
  end

  def create
    # Instantiate object
    @page = Page.new(page_params)
    @page.subject = @subject
    # save object
    if @page.save
      # If save succeeds, redirect to the index action
      flash[:notice] = "Page created successfully..."
      redirect_to(pages_path(:subject_id => @subject.id))
    else
      # If save fails, redirect the form so user can fix the problem
      render('new')
    end

  end

  def edit
    @page = Page.find(params[:id])
  end

  def update
    # Instantiate a new object usng form parameters
    @page = Page.find(params[:id])
    # Update the object
    if @page.update_attributes(page_params)
      # If save succeeds, redirect to the index action
      flash[:notice] = "Page updated successfully..."
      redirect_to(page_path(@page, :subject_id => @subject.id))
    else
      # If save fails, redirect the form so user can fix the problem
      render('edit')
    end

  end

  def delete
    @page = Page.find(params[:id])
  end

  def destroy
    @page = Page.find(params[:id])
    @page.destroy
    flash[:notice] = "Page '#{@page.name}' destroyed successfully..."
    redirect_to(pages_path(:subject_id => @subject.id))
  end

  private

  def page_params
    params.require(:page).permit(:name, :position, :visible, :permalink)
  end

  def find_subject
    @subject = Subject.find(params[:subject_id])
  end

  def set_page_count
    @page_count = @subject.pages.count
    if params[:action] == 'new' || params[:action] == 'create'
      @page_count += 1
    end
  end

end
