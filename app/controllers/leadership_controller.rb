require 'pathname'
class LeadershipController < ApplicationController

  before_filter :getuser,:settab
  advancedactions = [:editaboutnhs,:editsubmitguidelines,:reloadtaglist,:changeannouncements,:changesemester,:definesemesters,:changetumblrurl,:changevolunteermotivation,:changevolunteerpolicy,:changevolunteerdonationticket,:changepeoplemotivation,:changenhsemail]
  before_filter :req_loggedin,:req_officer
  before_filter :req_post, :only => [:exportsignups,:adddonation,:processtags,:newaccount_do,:editaccount,:editaccount_do,:runbackup]|advancedactions #no delete_backup
  before_filter :auto_backup, :only => [:deleteevent,:deleteaccount]|advancedactions
  before_filter :req_superofficer, :only => [:deleteevent,:newaccount_do,:newaccount,:deleteaccount,:deletebackup,:runbackup,:listbackups,:downloadbackup]|advancedactions
  
  def settab    
    @activetab = "leadership"
    @pagetitle = "Leadership CP &ndash; WalnutNHS".html_safe
  end
  def req_loggedin
    return render :text => "You must be logged in to see this page." if !isloggedin?
  end
  def req_officer
    return render :text => "You must be an officer to see this page." if !$user.officer?
  end
  def req_superofficer
    return render :text => "You must be an superofficer to see this page." if !$user.superofficer?
  end
  def req_administrator
    return render :text => "You must be an administrator to see this page." if !$user.administrator?
  end
  def req_post
    return render :text => "Only POST requests are accepted." if !request.post?
  end
  def req_eventid
    
  end
  def auto_backup
    backup_sqlite3 "automatic"
  end
  def index
    @pagetitle = "Leadership CP &ndash; WalnutNHS".html_safe
    @eventlist = Event.find(:all)
    @accountlist = Account.find(:all)
    
    @currentsemester = Setting.find(:first, :conditions => ['name = ?','currentsemester']).value || ""
    @semesterlist = Setting.find(:first, :conditions => ['name = ?','semesterlist']).value || ""
    @tumblrblogurl = Setting.find(:first, :conditions => ['name = ?','tumblrurl']).value || ""
    @volunteermotivation = Setting.find(:first, :conditions => ['name = ?','volunteermotivation']).value || ""
    @volunteerpolicy = Setting.find(:first, :conditions => ['name = ?','volunteerpolicy']).value || ""    
    @volunteerdonationticket = Setting.find(:first, :conditions => ['name = ?','volunteerdonationticket']).value || ""
    @peoplemotivation = Setting.find(:first, :conditions => ['name = ?','peoplemotivation']).value || ""
    @nhsemail = Setting.find(:first, :conditions => ['name = ?','nhsemail']).value || ""
    @announcements = Setting.find(:first, :conditions => ['name = ?','announcements']).value || ""
    @taglist = Setting.find(:first, :conditions => ['name = ?','taglist']).value || ""
    @aboutnhs = Setting.find(:first, :conditions => ['name = ?','aboutnhs']).value || ""
    @submitguidelines = Setting.find(:first, :conditions => ['name = ?','submitguidelines']).value || ""
    
  end
  def deleteevent
    return render :text => "Invalid event id." if !(/^[0-9]+$/.match(params[:eventid]))
    target_event = Event.find(params[:eventid])
    return render :text => "Cannot find that event" if target_event.blank?
    target_event.destroy
    return render :text => "<h2>Crushed event with ID #{target_event.id} into oblivion. If this was a mistake, tell the administrator immediately. It may be possible to use the backups to restore the data. Check the results at the <a href=\"/leadership/listevents\">event listing page</a>.</h2>"
  end
  def adddonation
    Signup.create(:account_id => params[:account_id],:event_id => params[:event_id],:pointvalue => params[:pointvalue],:difficulty => params[:difficulty],:semester => params[:semester],:status=>"COMPLETE",:completiondate=> Time.new)
    session[:message] = "#{params[:pointvalue]} #{params[:difficulty].capitalize} points have been assigned for this event."
    redirect_to "/leadership/managesignups?eventid=#{params[:event_id]}"
  end
  def deletedonation
    return render :text => "Invalid signup id." if !(/^[0-9]+$/.match(params[:signupid]))
    target_signup = Signup.find(params[:signupid])
    session[:message] = "Signup #{target_signup.id} has been destroyed."
    redirect_to "/leadership/managesignups?eventid=#{target_signup.event_id}"
    target_signup.destroy
  end
  def addvolunteer    
    return render :text => "Invalid event id." if !(/^[0-9]+$/.match(params[:eventid]))
    return render :text => "Invalid account id." if !(/^[0-9]+$/.match(params[:accountid]))
    target_event = Event.find(params[:eventid])
    target_account = Account.find(params[:accountid])
    return render :text => "Cannot find that event!" if target_event.blank?
    return render :text => "Cannot find that account" if target_account.blank?
    return render :text => "This function is for volunteering donations only, not for donation events." if target_event.donation
    signupcheck = Signup.find(:all,:conditions => ['account_id = ? AND event_id = ?',target_account.id,target_event.id])
    return render :text => "Already found a signup for that member." if !signupcheck.blank?
    Signup.create(:account => target_account,:event => target_event,:status => ((target_event.autoaccept)? "VOLUNTEER":"WAITLIST"),:pointvalue => nil,:difficulty => nil,:semester => nil,:completiondate => nil,:comments => nil)
    return render :nothing => true;
  end
  def managesignups_do
    return render :text => "Invalid event id." if !(/^[0-9]+$/.match(params[:event_id]))
    params[:signups].each do |su|
      return render :text => "Invalid signup id." if !(/^[0-9]+$/.match(su))
    end
    target_signups = Signup.find(:all,:conditions => ['id IN (' + params[:signups].join(",") + ')'])
    case params[:ms_action]
    when "assignpoints"
      target_signups.each do |su|
        su.update_attributes(:pointvalue => params[:pointvalue],:difficulty => params[:difficulty],:semester => params[:semester],:status=>"COMPLETE",:completiondate=> Time.new)
      end
    when "volunteerlist"
      target_signups.each do |su|
        su.update_attributes(:pointvalue => nil,:difficulty => nil,:semester => nil,:status => "VOLUNTEER")
      end
    when "waitlist"
      target_signups.each do |su|
        su.update_attributes(:pointvalue => nil,:difficulty => nil,:semester => nil,:status => "WAITLIST")
      end
    when "absent"
      target_signups.each do |su|
        su.update_attributes(:pointvalue => nil,:difficulty => nil,:semester => nil,:status => "ABSENT")
      end
    when "cancel"
      target_signups.each do |su|
        su.destroy
      end
    end
    redirect_to "/leadership/managesignups?eventid=#{params[:event_id]}"
  end
  def managesignups
    return render :text => "Invalid event id." if !(/^[0-9]+$/.match(params[:eventid]))
    @instance = Event.find(:first,:conditions => ['id = ?',params[:eventid]])
    return render :text => "Cannot find that event!" if @instance.blank?
    @volunteers = Signup.find(:all,:conditions => ['event_id = ?',params[:eventid]])
    @members = Account.find(:all,:order => "name")
    semesterlist_pre = Setting.find(:first, :conditions => ['name = ?','semesterlist']).value || ""
    @semesterlist = semesterlist_pre.split("\n")
    @pagetitle = "Managing event (#{@instance.name}) &ndash; WalnutNHS".html_safe
  end
  def exportsignups
    return render :text => "Invalid event id." if !(/^[0-9]+$/.match(params[:event_id]))
    @instance = Event.find(:first,:conditions => ['id = ?',params[:event_id]])
    return render :text => "Cannot find that event!" if @instance.blank?
    @volunteers = Signup.find(:all,:conditions => ['event_id = ?',params[:event_id]])
    @pagetitle = "#{@instance.name} Data &ndash; WalnutNHS".html_safe
    return render "exportsignups", :layout => nil
  end
  def listevents
    @pagetitle = "List events &ndash; WalnutNHS".html_safe
    @eventlist = Event.find(:all)
  end
  def newevent
    @pagetitle = "Create new event &ndash; WalnutNHS".html_safe
    @cplist = Account.find(:all, :conditions => ['privileges IN ("OFFICER","ADVISOR","SUPEROFFICER","ADMINISTRATOR")'], :order => 'name')
  end
  def newevent_do
    t = Event.create(:name => params[:ne_name],:description => params[:ne_description],:summary => params[:ne_summary],:eventstart => Time.parse(params[:ne_eventstart]),:eventend => Time.parse(params[:ne_eventend]),:signupstart => Time.parse(params[:ne_signupstart]),:signupend => Time.parse(params[:ne_eventend]),:activestart => Time.parse(params[:ne_activestart]),:activeend => Time.parse(params[:ne_activeend]),:autoaccept => (params[:ne_autoaccept] == "acceptthem"),:donation => (params[:ne_donation] == "isdonation"),:pointvalue => params[:ne_pointvalue],:difficulty => params[:ne_difficulty],:chairpeople => params[:ne_chairpeople],:comments => params[:ne_comments],:synopsis => params[:ne_synopsis])
    return render :text => "<h2>Created an event with ID #{t.id}. Check the results at the <a href=\"/leadership/listevents\">event listing page</a>.</h2>"
  end  
  def editevent
    return render :text => "Invalid event id." if !(/^[0-9]+$/.match(params[:eventid]))
    @instance = Event.find(:first,:conditions => ['id = ?',params[:eventid]])
    return render :text => "Cannot find that event!" if @instance.blank?
    @cplist = Account.find(:all, :conditions => ['privileges IN ("OFFICER","ADVISOR","SUPEROFFICER","ADMINISTRATOR")'], :order => 'name')
    @pagetitle = "Editing event (#{@instance.name}) &ndash; WalnutNHS".html_safe    
  end
  def editevent_do
    target = Event.find(params[:ne_id])
    target.update_attributes(:name => params[:ne_name],:description => params[:ne_description],:summary => params[:ne_summary],:eventstart => Time.parse(params[:ne_eventstart]),:eventend => Time.parse(params[:ne_eventend]),:signupstart => Time.parse(params[:ne_signupstart]),:signupend => Time.parse(params[:ne_eventend]),:activestart => Time.parse(params[:ne_activestart]),:activeend => Time.parse(params[:ne_activeend]),:autoaccept => (params[:ne_autoaccept] == "acceptthem"),:donation => (params[:ne_donation] == "isdonation"),:pointvalue => params[:ne_pointvalue],:difficulty => params[:ne_difficulty],:chairpeople => params[:ne_chairpeople],:comments => params[:ne_comments],:synopsis => params[:ne_synopsis])
    return render :text => "<h2>Saved event with ID #{target.id}. Check the results at the <a href=\"/leadership/listevents\">event listing page</a>.</h2>"
  end
  def listaccounts
    @pagetitle = "List accounts &ndash; WalnutNHS".html_safe
    @accountlist = Account.find(:all)
  end
  def newaccount
    @pagetitle = "Create new account &ndash; WalnutNHS".html_safe
  end
  def newaccount_do
    return render :text => "Invalid option for privileges. Go back and try again." if !(params[:na_privileges] == "MEMBER" || (params[:na_privileges] == "OFFICER" && $user.superofficer?) || (params[:na_privileges] == "SUPEROFFICER" && $user.administrator?) || (params[:na_privileges] == "ADVISOR" && $user.administrator?))
    t = Account.create(:studentid => params[:na_studentid],:name => params[:na_name],:password => params[:na_password],:title => params[:na_title],:privileges => params[:na_privileges],:year => params[:na_year],:email => params[:na_email],:telephone => params[:na_telephone],:contact => params[:na_contact],:schedule => params[:na_schedule],:group_id => params[:na_group_id],:comments => params[:na_comments],:privacy => 0)
    return render :text => "<h2>Created an account with ID #{t.id}. Check the results at the <a href=\"/leadership/listaccounts\">account listing page</a>.</h2>"
  end
  def editaccount
    return render :text => "Invalid account id." if !(/^[0-9]+$/.match(params[:accountid]))
    @member = Account.find(:first,:conditions => ['id = ?',params[:accountid]])
    return render :text => "Cannot find that account!" if @member.blank?
    @pagetitle = "Editing account (#{@member.name}) &ndash; WalnutNHS".html_safe
  end
  def editaccount_do
    return render :text => "Invalid option for privileges. Go back and try again." if !(params[:na_privileges] == "nochange" || params[:na_privileges] == "MEMBER" || (params[:na_privileges] == "OFFICER" && $user.superofficer?) || (params[:na_privileges] == "SUPEROFFICER" && $user.administrator?) || (params[:na_privileges] == "ADVISOR" && $user.administrator?))
    target = Account.find(params[:na_id])
    params[:na_group_id] = nil if params[:na_group_id].blank?
    params[:na_privileges] = target.privileges if params[:na_privileges] == "nochange"
    target.update_attributes(:studentid => params[:na_studentid],:name => params[:na_name],:password => params[:na_password],:title => params[:na_title],:privileges => params[:na_privileges],:year => params[:na_year],:email => params[:na_email],:telephone => params[:na_telephone],:contact => params[:na_contact],:schedule => params[:na_schedule],:group_id => params[:na_group_id],:comments => params[:na_comments])
    return render :text => "<h2>Saved account with ID #{target.id}. Check the results at the <a href=\"/leadership/listaccounts\">account listing page</a>.</h2>"
  end
  def deleteaccount
    return render :text => "Invalid account id." if !(/^[0-9]+$/.match(params[:accountid]))
    @member = Account.find(params[:accountid])
    return render :text => "Cannot find that account!" if @member.blank?
    @member.destroy
    return render :text => "<h2>Crushed account with ID #{@member.id} into oblivion. If this was a mistake, tell the administrator immediately. It may be possible to use the backups to restore the data. Check the results at the <a href=\"/leadership/listaccounts\">account listing page</a>.</h2>"
  end
  def definesemesters
    Setting.find(:first,:conditions=>['name = ?','semesterlist']).update_attributes(:value => params[:semesterlist])
    session[:message] = "Saved semester list to database."
    redirect_to "/leadership"    
  end
  def changesemester
    Setting.find(:first,:conditions=>['name = ?','currentsemester']).update_attributes(:value => params[:currentsemester])
    session[:message] = "Changed semester to " + params[:currentsemester] + "."
    redirect_to "/leadership"
  end
  def changetumblrurl
    Setting.find(:first,:conditions=>['name = ?','tumblrurl']).update_attributes(:value => params[:tumblrblogurl])
    session[:message] = "Changed tumblrurl to " + params[:tumblrblogurl] + "."
    redirect_to "/leadership"    
  end
  def changevolunteermotivation
    Setting.find(:first,:conditions=>['name = ?','volunteermotivation']).update_attributes(:value => params[:volunteermotivation])
    session[:message] = "Volunteer motivation has been updated! Check the <a href=\"/volunteer\">volunteer tab</a> to see it.".html_safe
    redirect_to "/leadership"
  end
  def changevolunteerpolicy
    Setting.find(:first,:conditions=>['name = ?','volunteerpolicy']).update_attributes(:value => params[:volunteerpolicy])
    session[:message] = "Volunteer policy has been updated! Check the <a href=\"/volunteer\">volunteer tab</a> to see it.".html_safe
    redirect_to "/leadership"    
  end
  def changevolunteerdonationticket
    Setting.find(:first,:conditions=>['name = ?','volunteerdonationticket']).update_attributes(:value => params[:volunteerdonationticket])
    session[:message] = "Volunteer donation ticket info has been updated! Check the <a href=\"/volunteer\">volunteer tab</a> to see it.".html_safe
    redirect_to "/leadership"
  end
  def changepeoplemotivation
    Setting.find(:first,:conditions=>['name = ?','peoplemotivation']).update_attributes(:value => params[:peoplemotivation])
    session[:message] = "People motivation has been updated! Check the <a href=\"/people\">people tab</a> to see it.".html_safe
    redirect_to "/leadership"
  end
  def changenhsemail
    Setting.find(:first,:conditions=>['name = ?','nhsemail']).update_attributes(:value => params[:nhsemail])
    session[:message] = "Default NHS email has been updated!"
    redirect_to "/leadership"    
  end
  def changeannouncements
    Setting.find(:first,:conditions=>['name = ?','announcements']).update_attributes(:value => params[:announcements])
    session[:message] = "Announcements list has been updated!"
    redirect_to "/leadership"    
  end
  def reloadtaglist
    Setting.find(:first,:conditions=>['name = ?','taglist']).update_attributes(:value => params[:taglist])
    session[:message] = "Tag list has been updated!"
    redirect_to "/leadership"
  end
  def editaboutnhs
    Setting.find(:first,:conditions=>['name = ?','aboutnhs']).update_attributes(:value => params[:aboutnhs])
    session[:message] = "About NHS text has been updated!"
    redirect_to "/leadership"
  end
  def editsubmitguidelines
    Setting.find(:first,:conditions=>['name = ?','submitguidelines']).update_attributes(:value => params[:submitguidelines])
    session[:message] = "Submit guidelines have been updated!"
    redirect_to "/leadership"
  end
  
  def listbackups
    @pagetitle = "List backups &ndash; WalnutNHS".html_safe
    @backups = Dir.glob(Rails.root.join("db/backups/*.tar.gz")).sort_by{ |f| File.mtime(f) }
  end
  def runbackup
    bkresult = backup_sqlite3 "user"
    session[:message] = "Created a backup " + bkresult.to_s + "."
    redirect_to "/leadership/listbackups"
  end
  def deletebackup
    @backups = Dir.glob(Rails.root.join("db/backups/*.tar.gz"))
    @backups.each do |bk|
      if params[:backup] == Pathname.new(bk).basename.to_s
        File.delete("db/backups/"+Pathname.new(bk).basename.to_s)
        session[:message] = "Deleted the backup " + Pathname.new(bk).basename.to_s + "."
      end
    end
    redirect_to "/leadership/listbackups"
  end
  def downloadbackup
    @backups = Dir.glob(Rails.root.join("db/backups/*.tar.gz"))
    @backups.each do |bk|
      if params[:backup] == Pathname.new(bk).basename.to_s
        send_file 'db/backups/' + Pathname.new(bk).basename.to_s , :type=>"application/x-gzip", :x_sendfile=>true
      end
    end
  end
  def processtags
    i = params[:input]
    summary = params[:summary]
    eventstart = Time.parse(params[:eventstart]).to_datetime
    eventend = Time.parse(params[:eventend]).to_datetime
    signupstart = Time.parse(params[:signupstart]).to_datetime
    signupend = Time.parse(params[:signupend]).to_datetime
    activestart = Time.parse(params[:activestart]).to_datetime
    activeend = Time.parse(params[:activeend]).to_datetime
    pointvalue = params[:pointvalue]
    difficulty = params[:difficulty]
    chairpeople = params[:chairpeople]
    
    ret = hsc i
    ret.gsub! '%SUMMARY%', hsc(summary)
    ret.gsub! '%DATETIME%', '%STARTTIME% to %ENDTIME%'
    ret.gsub! '%STARTTIME%', eventstart.to_datetime.strftime('%B %d, %Y %l:%M%p')
    if eventstart.to_datetime.strftime('%B %d, %Y') == eventend.to_datetime.strftime('%B %d, %Y') #same day for start and end
      ret.gsub! '%ENDTIME%', eventend.to_datetime.strftime('%l:%M%p')      
    else
      ret.gsub! '%ENDTIME%', eventend.to_datetime.strftime('%B %d, %Y %l:%M%p')
    end
    
    
    ret.gsub! '%SIGNUPSTART%', signupstart.to_datetime.strftime('%B %d, %Y %l:%M%p')
    if signupstart.to_datetime.strftime('%B %d, %Y') == signupend.to_datetime.strftime('%B %d, %Y') #same day for start and end
      ret.gsub! '%SIGNUPEND%', signupend.to_datetime.strftime('%l:%M%p')      
    else
      ret.gsub! '%SIGNUPEND%', signupend.to_datetime.strftime('%B %d, %Y %l:%M%p')
    end
    
    
    ret.gsub! '%ACTIVESTART%', activestart.to_datetime.strftime('%B %d, %Y %l:%M%p')
    if activestart.to_datetime.strftime('%B %d, %Y') == activeend.to_datetime.strftime('%B %d, %Y') #same day for start and end
      ret.gsub! '%ACTIVEEND%', activeend.to_datetime.strftime('%l:%M%p')      
    else
      ret.gsub! '%ACTIVEEND%', activeend.to_datetime.strftime('%B %d, %Y %l:%M%p')
    end
    
    
    ret.gsub! '%POINTVALUE%', pointvalue.to_s
    ret.gsub! '%DIFFICULTY%', difficulty.capitalize
    
    if ret.include? '%CHAIRPEOPLE%' #don't want to do this costly operation if there is no tag
      chairs = chairpeople.split(',')
      chaircondition = ""
      chairs.length.times{chaircondition += "id = ? OR "}
      chaircondition.slice!(-4,4)
      chaircondition += "1=2 " if chairpeople.blank?
      
      
      chairdata = []
      chairresult = Account.find(:all,:select => [:id,:name],:conditions => [chaircondition]|chairs )
      chairresult.each do |cha|
        chairdata |= ['<a href="/people/volunteer/'+cha.id.to_s+'">'+cha.name+'</a>']
      end
              
      ret.gsub! '%CHAIRPEOPLE%',chairdata.join(', ')
    end
    
    return render :text => (ret.gsub("\n", "<br />").html_safe)
  end
end

#backups current configured for SQLITE3 ONLY
def backup_sqlite3 (prefix)
  bkfilename = "db/backups/#{prefix}-backup-" + Time.now.strftime("%Y%m%d%H%M%S") + ".tar.gz"
  `tar -zcvf #{bkfilename} db/*.sqlite3`
  bkfilename
end
