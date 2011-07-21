class Group < ActiveRecord::Base
  has_many :accounts
  
  def leader
    ld = Account.find(:first,:conditions => ["group_id = ? AND privileges IN ('ADVISOR','OFFICER','SUPEROFFICER','ADMINISTRATOR')",id])
    if ld.blank?
      Account.find(:first,:conditions => ["group_id = ?",id])
    else
      ld
    end
  end
  def members
    Account.find(:all,:conditions => ["group_id = ?",id],:order=>"name")
  end
end
