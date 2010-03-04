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
end
