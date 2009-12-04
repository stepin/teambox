class Conversation < RoleRecord
  has_many :uploads
  has_many :comments, :as => :target, :order => 'created_at DESC', :dependent => :destroy

  serialize :watchers_ids

  attr_accessible :name
  attr_accessor :body

  def after_create
    self.project.log_activity(self,'create')
    self.add_watcher(self.user) 

    comment = self.comments.new do |comment|
      comment.project_id = self.project_id
      comment.user_id = self.user_id
      comment.body = self.body
    end

    comment.save!
  end
  
  def after_destroy
    Activity.destroy_all  :target_id => self.id, :target_type => self.class.to_s
  end

  def owner?(u)
    user == u
  end

  def after_comment(comment)
    notify_new_comment
  end

  def notify_new_comment
    comment ||= self.comments.last
    self.watchers.each do |user|
      unless user == comment.user
        Emailer.deliver_notify_conversation(user, self.project, self)
      end
    end
  end  
end