module GroupsHelper
  def groups_column
    render :partial => 'groups/column', :locals => {
      :group => @group,
      :groups => current_user.groups }
  end
  
  def list_groups(groups)
    render :partial => 'groups/group', :collection => groups
  end
  
  def group_icon(group)
    src = group.has_logo? ? group.logo.url(:icon) : "/images/icon_default.png"
    link_to "<img class='icon' src='#{src}' alt='#{group.name}'/>", group_path(group)
  end
  
  def group_project_form()
    render :partial => 'groups/project_form', :locals => {
      :group => @group,
      :projects => @current_user.projects - @group.projects }
  end
  
  def add_group_project_link
    link_to_function t('.add_project'), show_group_project_form, :id => 'group_project_link'
  end
  
  def show_group_project_form
    update_page do |page|
      page.show "group_project_form"
      page.hide "group_project_link"
    end
  end
  
  def hide_group_project_form
    update_page do |page|
      page.hide "group_project_form"
      page.show "group_project_link"
    end
  end
end
