class SectionsController < ApplicationController

  layout 'admin'

  before_action :confirm_logged_in
  before_action :find_page
  before_action :set_section_count, :only => [:new, :create, :edit, :update]

  def index
    @sections = @page.sections.sorted
  end

  def show
    @section = Section.find(params[:id])
  end

  def new
    @section = Section.new(:page_id => @page.id)
  end

  def create
    # Instantiate a new object usng form parameters
    @section = Section.new(section_params)
    @section.page = @page
    # Save the object
    if @section.save
      # If save succeeds, redirect to the index action
      flash[:notice] = "Subject created successfully..."
      redirect_to(sections_path(:page_id => @page.id))
    else
      # If save fails, redirect the form so user can fix the problem
      render('new')
    end
  end

  def edit
    @section = Section.find(params[:id])
  end

  def update
    # Instantiate a new object usng form parameters
    @section = Section.find(params[:id])
    # Update the object
    if @section.update_attributes(section_params)
      # If save succeeds, redirect to the index action
      flash[:notice] = "Section updated successfully..."
      redirect_to(section_path(@section, :page_id => @page.id))
    else
      # If save fails, redirect the form so user can fix the problem
      render('edit')
    end
  end

  def delete
    @section = Section.find(params[:id])
  end

  def destroy
    @section = Section.find(params[:id])
    @section.destroy
    flash[:notice] = "Section '#{@section.name}' destroyed successfully..."
    redirect_to(sections_path(:page_id => @page.id))
  end

  private

  def section_params
    params.require(:section).permit(:name, :position, :visible, :content_type, :content)
  end

  def find_page
    @page = Page.find(params[:page_id])
  end

  def set_section_count
    @section_count = @page.sections.count
    if params[:action] == 'new' || params[:action] == 'create'
      @section_count += 1
    end
  end

end
