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
    src = group.has_logo? ? group.logo.url(:icon) : "/images/header_logo_black.png"
    link_to "<img class='icon' src='#{src}' alt='#{group.name}'/>", group_path(group)
  end
  
  def group_project_form()
    render :partial => 'groups/project_form', :locals => {
      :group => @group,
      :projects => @current_user.projects - @group.projects }
  end
  
  def add_group_project_link
    link_to_function t('groups.show.add_project'), show_group_project_form, :id => 'group_project_link'
  end
  
  def remove_member_link(group,member,user)
    if !group.owner?(member)
      delete_member_link(group,member)
    end
  end
  
  def delete_member_link(group,member)
    link_to_remote t('.remove'), :url => members_group_path(@group, 'group[member_ids][]' => member.id), :method => :delete
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
  
  def invite_by_group_search(target,invitation)
    render :partial => 'groups/search',
      :locals => {
        :target => target,
        :invitation => invitation }
  end
  
  def list_members(group, users)
    render :partial => 'member', 
      :collection => users, 
      :as => :member, :locals => {:group => group}
  end
  
  def member_header(group, user)
    render :partial => 'groups/header', 
      :locals => { 
        :group => group,
        :user => user }
  end
end
