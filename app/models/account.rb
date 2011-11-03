require "digest/md5"

class Account < ActiveRecord::Base
  belongs_to :group
  has_many :events, :through => :signups
  has_many :signups
  before_destroy {|acc| Signup.destroy_all(:account_id => acc.id)}
  before_destroy {|acc| Posting.destroy_all(:account_id => acc.id)}
  
  validates_presence_of :name, :studentid, :password #other values can be defaulted
  validates_uniqueness_of :studentid
  validates_inclusion_of :privileges, :in => %w( ADVISOR MEMBER OFFICER SUPEROFFICER ADMINISTRATOR )
  @@restrictedurls = %w[login blog volunteer tumblrconnect.js people settings leadership bypass] #check for collisions with c14n, but what a fucked-up name for your child..
  def c14n	
	return "#{id}-#{name.gsub(/[^a-zA-Z0-9]/,'-')}" if Account.find(:all,:conditions => ['name = ?',name]).size != 1
	return name.gsub(/[^a-zA-Z0-9]/,'-') if (Account.find(:all,:conditions => ['name LIKE ?',"#{first_name} %"]).size != 1) || @@restrictedurls.include?(first_name) || first_name.blank? #intentional space after first_name
	return first_name
  end
  def first_name
	name.split.first
  end
  def last_name
	name.split.last
  end
  def account_path
	"/#{c14n}"
   # "/people/volunteer/#{id}"
  end
  def advisor?
    privileges.upcase == "ADVISOR"
  end
  def officer?
    %w{ OFFICER ADVISOR SUPEROFFICER ADMINISTRATOR }.include? privileges.upcase
  end
  def superofficer?
    %w{ SUPEROFFICER ADMINISTRATOR }.include? privileges.upcase 
  end
  def administrator?
    privileges.upcase == "ADMINISTRATOR"    
  end
  
  def safe_text (text)
    enc = [] 
    enc << rand(255)
    text.length.times do |i|
      enc << text[i] - enc.last
    end
    '<script type="text/javascript">'+"var t=[#{enc.join(',')}]; for (var i=1; i<t.length; i++) { document.write(String.fromCharCode(t[i]+t[i-1])); }"+'</script>'
  end
  def processcontact
    ret = hsc contact
    ret.gsub! '%EMAIL%', safe_text(email.to_s) #'<script type="text/javascript">document.write("' + email.to_s.split(//).join('"+"') + '");</script>';
    ret.gsub! '%PHONE%', telephone.to_s
    ret.gsub! '%TELEPHONE%', telephone.to_s
    ret.gsub! '%YEAR%', year.to_s
    ret.gsub! '%TITLE%', title.to_s
    
    ret.gsub!("\n", "<br />")
    ret.gsub("\\n", "<br />").html_safe
  end
  def picturepath
    if FileTest.exists?(RAILS_ROOT + "/public/pictures/"+id.to_s+".jpg")
      "/pictures/#{id}.jpg"
    elsif FileTest.exists?(RAILS_ROOT + "/public/pictures/"+id.to_s+".png")
      "/pictures/#{id}.png"
    else
      "http://gravatar.com/avatar/" + Digest::MD5.hexdigest(email) + "?s=256&d=mm" # used to be "/images/none.png"
    end
  end
  def haspicture
    if FileTest.exists?(RAILS_ROOT + "/public/pictures/"+id.to_s+".jpg") || FileTest.exists?(RAILS_ROOT + "/public/pictures/"+id.to_s+".png")
      true
    else
      false
    end
    
  end
end