class Member < ActiveRecord::Base
  belongs_to :user

  def self.search(search, page)
    paginate(:page => page, 
             :per_page => 50,
             :conditions => ['first_name like ? or last_name like ?', "%#{search}%","%#{search}%"],
             :order => 'last_name')
  end
  
  def self.visitors(page)
    paginate(:page => page, 
             :per_page => 50,
             :conditions => ['status = ?', "visitor"],
             :order => 'last_name')
  end
  
end
