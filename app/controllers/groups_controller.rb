class GroupsController < ApplicationController
  skip_before_filter :load_project
  before_filter :load_group, :except => [:index, :new, :create]
  before_filter :set_page_title
  
  def index
    @group = current_user.group
    @groups = current_user.groups
  end
  
  def new
  end
  
  def create
  end
  
  def edit
  end
  
  def update
  end
  
  def destroy
  end
  
private

  def load_group
    begin
      @group = Group.find_by_permalink(params[:id])
    rescue
      flash[:error] = "Could not find group #{params[:id]}"
      redirect_to groups_path
      return false
    end
  end

end
