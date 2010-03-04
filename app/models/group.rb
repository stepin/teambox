class Group < ActiveRecord::Base
  belongs_to :user
  has_many :projects, :dependent => :nullify
  has_many :invitations
  has_and_belongs_to_many :users
  
  acts_as_paranoid
  
  has_attached_file :logo,
    :styles => { 
      :top => ["134x24#", :jpg],
      :icon => ["96x72#", :png] },
    :url  => "/logos/:id/:style.:extension",
    :path => ":rails_root/public/logos/:id/:style.:extension"

  validates_attachment_size :logo, :less_than => 10.megabytes, :if => :has_logo?
  
  def owner?(user)
    self.user_id == user.id
  end
  
  def admin?(user)
    self.user_id == user.id
  end
  
  def has_logo?
    !logo.original_filename.nil?
  end
  
  def add_user(user)
    self.user_ids << user.id
    self.user_ids.uniq!
    save(false)
  end
  
  def remove_user(user)
    self.user_ids.remove(user.id)
    save(false)
  end
  
  def to_param
    permalink
  end
  
end
