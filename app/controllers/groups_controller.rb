class GroupsController < ApplicationController
  skip_before_filter :load_project
  before_filter :load_group, :except => [:index, :new, :create]
  before_filter :set_page_title
  
  def index
    @group = current_user.group
    @groups = current_user.groups
  end
  
  def show
    @contacts = []
    @invitations = Invitation.find(:all, :conditions => {:group_id => @group.id})
  end
  
  def new
    @group = Group.new
  end
  
  def create
    unless current_user.group.nil?
      flash[:error] = "You already own a group!"
      redirect_to groups_path
      return
    end
    
    @group = Group.new(params[:group])
    @group.user = current_user
    
    respond_to do |f|
      if @group.save
        @group.add_user(current_user)
        flash[:notice] = I18n.t('groups.new.created')
        f.html { redirect_to group_path(@group) }
      else
        flash[:error] = I18n.t('groups.new.invalid_group')
        f.html { render :new }
      end
    end
  end
  
  def edit
  end
  
  def update
    respond_to do |f|
      if @group.update_attributes(params[:group])
        if params[:only_logo]
          f.html { logo }
        else
          f.html { redirect_to group_path(@group) }
        end
      else  
        flash[:error] = I18n.t('groups.new.invalid_group')
        if params[:only_logo]
          f.html { logo }
        else
          f.html { render :new }
        end
      end
    end
  end
  
  def destroy
    @group.destroy
    respond_to do |f|
      f.html { redirect_to groups_path }
    end
  end
  
  def logo
    case request.method
    when :delete
      @group.logo = nil
      @group.save!
    end
    render :logo, :layout => 'upload_iframe'
  end
  
  def projects
    saved = false
    list = (params[:group][:project_ids] || []) rescue []
    list = list.map(&:to_i)
    
    case request.method
    when :put
      @group.project_ids = (@group.project_ids + list).uniq
      saved = @group.save
    when :post
      saved = false
    when :delete
      @group.project_ids = @group.project_ids - list
      saved = @group.save
    end
    
    respond_to do |f|
      f.html {redirect_to group_path(@group)}
      f.js {@projects = @group.projects}
    end
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
