class VolunteerController < ApplicationController
  before_filter :getuser,:settab
  before_filter :req_loggedin, :only => [:seesignups]
  before_filter :req_loggedin, :req_post, :only => [:signup,:cancel,:discuss,:editdiscuss]
  before_filter :check_eventid, :only => [:signup,:cancel,:discuss,:showevent,:editdiscuss]
  def settab
    @activetab = "volunteer"
    @pagetitle = "Volunteer &ndash; WalnutNHS".html_safe
    @pagedescription = "Find volunteer opportunities through WalnutNHS events. Contains volunteer and donation listings and policies for members of WalnutNHS."
    @pagekeywords = "events, listings, volunteer, donation, WalnutNHS, Walnut, National Honor Society, Walnut High, Walnut High School"
  end
  def req_loggedin
    return render :text => "You must be logged in to see this page.#{goback}" if !isloggedin?
  end
  def req_post
    return render :text => "Only POST requests are accepted.#{goback}" if !request.post?
  end
  def check_eventid
    return render :text => "Invalid event id.#{goback}" if !params[:event_id].to_s.match(/^[0-9]+$/)
  end
  def index
    first_event = Event.find(:first,:conditions => ['donation = ?','f'],:order => "activestart")
    last_event = Event.find(:first,:conditions => ['donation = ?','f'],:order => "activeend DESC")
    @archivelinks = [];
    if !(first_event.blank? || last_event.blank?)
 	   first_event.activestart.strftime("%Y")..last_event.activeend.strftime("%Y").each do |year|
  	    (1..12).each do |month|
  	      if !((year == first_event.activestart.strftime("%Y").to_i && month.to_i < first_event.activestart.strftime("%m").to_i) ||
			 (year == last_event.activeend.strftime("%m").to_i && month.to_i > last_event.activeend))
  	      #Time.local(year,month,Time::days_in_month(month, year)) >= first_event.activestart && Time.local(year,month) <= last_event.activeend
  	        @archivelinks << Time.local(year,month)
  	      end
  	    end
  	  end
      @archivelinks.reverse!
    end

    @mainline = Time.now
    @subline = nil
    @supline=nil
    if (Date.civil(Date.today.year, Date.today.month, -1).day - 10 < Time.now.day) #strictly less
    	@supline = Date.today.at_beginning_of_month.next_month.to_time #assuming 12 months in every year
    elsif (Time.now.day < 5)
    	@subline = Date.today.at_beginning_of_month.months_since(-1).to_time #assuming 12 months in every year
    end
    cutoff = Time.now.in(86400).strftime('%Y-%m-%d')
    cutoff2 = Time.now.in(30*86400).strftime('%Y-%m-%d')
=begin
   @upcoming = Event.find(:all,:conditions => ['eventstart >= ? AND eventend <= ? AND donation = ?',cutoff,cutoff2,false],:order=>"CASE
        WHEN difficulty='HARD' THEN 1
        WHEN difficulty='MEDIUM' THEN 2
        WHEN difficulty='EASY' THEN 3
        ELSE 4
      END, pointvalue DESC, eventstart",:limit => 5)
=end
    @volunteermotivation = Setting.find_by_name('volunteermotivation').value || ""
    @volunteerpolicy = Setting.find_by_name('volunteerpolicy').value || ""
    @volunteerdonationticket = Setting.find_by_name('volunteerdonationticket').value || ""
    @volunteerannouncement = Setting.find_by_name('volunteerannouncement').value || ""
  end
  def signup
    return render :text => "Already signed up.#{goback}" if (Signup.find(:all,:conditions => ['account_id = ? AND event_id = ?',$user.id,params[:event_id]]).size != 0)
    target_event = Event.find(params[:event_id])
    return render :text => "Could not find event specified.#{goback}" if target_event.blank?
    newsignup = Signup.create(:account => $user, :event => target_event, :status => ((target_event.autoaccept)? "VOLUNTEER":"WAITLIST"), :pointvalue => nil, :difficulty => nil, :semester => nil, :completiondate => nil, :comments => nil)
    #record "SIGNUP A#{$user.id} E#{params[:event_id]} S#{newsignup.id}", "IP: #{request.host}"
    session[:message] = "You have been signed up as a registered volunteer for #{target_event.name}." if target_event.autoaccept
    session[:message] = "You have been added to the waitlist for #{target_event.name}. Wait for a chairperson to call you before coming to the event." if !target_event.autoaccept
    return render :nothing => true
  end
  def cancel
    target_signup = Signup.find(:first,:conditions => ['account_id = ? AND event_id = ?',$user.id,params[:event_id]])
    return render :text => "Already canceled or no signup found.#{goback}" if target_signup.blank?
    #record "CANCEL A#{$user.id} E#{params[:event_id]} S#{target_signup.id}", "IP: #{request.host}"
    Signup.destroy(target_signup)
    return render :nothing => true
  end
  def discuss
    #todo rate limiting
    return render :text => "You forgot to type anything!#{goback}" if params[:discuss_content].blank?
    return render :text => "It looks like you already said that. Did you submit twice?#{goback}" if (Posting.find(:all,:conditions => ['account_id = ? AND content = ?',$user.id,params[:discuss_content]]).size != 0)
    return render :text => "Woah, slow down. You're posting comments too quickly.#{goback}" if (Posting.find(:all,:conditions => ['account_id = ? AND created_at > ?',$user.id,15.seconds.ago.strftime('%Y-%m-%d %H:%M:%S')]).size != 0)
    target_event = Event.find(params[:event_id])
    return render :text => "Could not find event specified.#{goback}" if target_event.blank?
    if !params[:reply_to].blank?
      target_reply = Posting.find(:first,:conditions => ['id = ? AND event_id = ?',params[:reply_to],params[:event_id]])
      return render :text => "Could not find the discussion specified." if target_reply.blank? #this may create orphans, but fuck it..
    end
    newposting = Posting.create(:account => $user,:event => target_event,:content => params[:discuss_content],:sticky => false,:reply_to => params[:reply_to] || nil)
	NhsMailer.new_comment(newposting).deliver
    #record "DISCUSS A#{$user.id} E#{params[:event_id]} P#{newposting.id}" + ((params[:reply_to].blank?)?"":" RA#{target_reply.id}"), "IP: #{request.host}"
    redirect_to target_event.event_path
  end
  def editdiscuss
    return render :text => "You forgot to type anything!#{goback}" if params[:discuss_content].blank?
    target_event = Event.find(params[:event_id])
    return render :text => "Could not find event specified.#{goback}" if target_event.blank?
    return render :text => "Could not find the posting specified.#{goback}" if Posting.find(:all,:conditions => ['id = ? AND event_id = ? AND account_id = ?',params[:posting_id],params[:event_id],$user[:id]]).size != 1
    target_posting = Posting.find(:first,:conditions => ['id = ? AND event_id = ? AND account_id = ?',params[:posting_id],params[:event_id],$user[:id]])

    target_posting.content = params[:discuss_content]
    target_posting.save
    #record "EDIT_DISCUSS A#{$user.id} E#{params[:event_id]} P#{target_posting.id}", "IP: #{request.host}"
    redirect_to target_event.event_path
  end
  def showevent
    @tumblrurl = Setting.find_by_name('tumblrurl').value || ""
    @listing = Event.find(params[:event_id])
    return render :text => "Can't find event.#{goback}" if @listing.blank?
    @pagetitle = "#{@listing.name} &ndash; WalnutNHS".html_safe
    @pagedescription = "#{@listing.name} details: #{@listing.summary}"
    @pagekeywords = "#{@listing.name}, listings, volunteer, donation, WalnutNHS, Walnut, National Honor Society, Walnut High, Walnut High School"
    if isloggedin?
      @sign = Signup.find(:first,:conditions => ['account_id = ? AND event_id = ?',$user.id,params[:event_id]])
    end
    if @sign.blank?
      @signupstatus = "Not signed up"
      @signupcolor = "#666"
    elsif @sign.status == "WAITLIST"
      @signupstatus = "Waiting list"
      @signupcolor = "#222"
    elsif @sign.status == "VOLUNTEER"
      @signupstatus = "Registered as volunteer"
      @signupcolor = "#3f8eaf"
    elsif @sign.status == "ABSENT"
      @signupstatus = "Marked absent"
      @signupcolor = "#af2020"
    elsif @sign.status == "DENIED"
      @signupstatus = "Denied as volunteer"
      @signupcolor = "#573caf"
    elsif @sign.status == "COMPLETE"
      @signupstatus = "Volunteering completed"
      @signupcolor = "#5d721c"
    end

    @signuproster = Signup.find(:all,:conditions => ['event_id = ?',params[:event_id]])
    @num_v = {}
    %w{ WAITLIST VOLUNTEER ABSENT DENIED COMPLETE }.each do |st|
      @num_v[st] = 0
    end
    @signuproster.each do |su|
      @num_v[su.status] += 1
    end

    @postinglist = Posting.find(:all,:conditions => ['event_id = ?',params[:event_id]])

    @relatedevents = Event.find(:all,:conditions => ['name LIKE ?',"%#{@listing.name.gsub(/\(.*\)/i,"").gsub(/^\s+/,"").gsub(/\s+$/,"").downcase}%"],:order => "eventstart ASC")

  end
  def activelisting
	return render :text => "obsolete"
    @pagetitle = "Active Event Listings &ndash; WalnutNHS".html_safe
    @target_date = DateTime.current
    current = @target_date.strftime('%Y-%m-%d %H:%M:%S')
    order = "!donation,(eventstart > now()),eventstart asc,pointvalue DESC"
    @hardlisting = Event.find(:all,:conditions => ['activestart <= ? AND activeend >= ? AND difficulty=?',current,current,"HARD"],:order => order)
    @mediumlisting = Event.find(:all,:conditions => ['activestart <= ? AND activeend >= ? AND difficulty=?',current,current,"MEDIUM"],:order => order)
    @easylisting = Event.find(:all,:conditions => ['activestart <= ? AND activeend >= ? AND difficulty=?',current,current,"EASY"],:order => order)

=begin
    @listing = Event.find(:all,:conditions => ['activestart <= ? AND activeend >= ?',current,current],:order=>"CASE
    WHEN difficulty='HARD' THEN 1
    WHEN difficulty='MEDIUM' THEN 2
    WHEN difficulty='EASY' THEN 3
    ELSE 4
  END, pointvalue DESC, eventstart")
=end
    session[:volunteergate] = "active"
  end
  def archivelisting
    return render :text => "Invalid year and month.#{goback}" if !params[:year].to_s.match(/^[0-9]{4}$/) || !params[:month].to_s.match(/^[0-9]{1,2}/)
    @target_date = DateTime.civil_from_format(:local,params[:year].to_i,params[:month].to_i).to_time
    @end_date = DateTime.civil_from_format(:local,params[:year].to_i,params[:month].to_i,Time::days_in_month(params[:month].to_i, params[:year].to_i),23,59,59).to_time # so that it includes absolutely everything... well almost. If an event's entire active period takes place within the 1000 milliseconds of the last second of a month, then it will not show up in any archive element.
    current = @target_date.strftime('%Y-%m-%d %H:%M:%S')
    capital = @end_date.strftime('%Y-%m-%d %H:%M:%S') #Bug fixed. This way all events will be shown in at least 1 archive listing.
    @pagetitle = "#{@target_date.strftime('%B %Y')} Listings &ndash; WalnutNHS".html_safe

    c2 = Time.zone.now.strftime('%Y-%m-%d %H:%M:%S')
    order = "donation asc,(eventstart < '#{c2}'),eventstart asc,pointvalue DESC"
    @hardlisting = Event.find(:all,:conditions => ['activestart <= ? AND activeend >= ? AND difficulty=?',capital,current,"HARD"],:order => order)
    @mediumlisting = Event.find(:all,:conditions => ['activestart <= ? AND activeend >= ? AND difficulty=?',capital,current,"MEDIUM"],:order => order)
    @easylisting = Event.find(:all,:conditions => ['activestart <= ? AND activeend >= ? AND difficulty=?',capital,current,"EASY"],:order => order)
=begin
    @listing = Event.find(:all,:conditions => ['activestart <= ? AND activeend >= ?',capital,current],:order=>"CASE
    WHEN difficulty='HARD' THEN 1
    WHEN difficulty='MEDIUM' THEN 2
    WHEN difficulty='EASY' THEN 3
    ELSE 4
  END, pointvalue DESC, eventstart")
=end
    session[:volunteergate] = "#{params[:year]} #{params[:month]}"
  end
  def alllisting
    @pagetitle = "All Event Listings &ndash; WalnutNHS".html_safe

    @hardlisting = Event.find(:all,:conditions => ['difficulty=?',"HARD"],:order => "eventstart,pointvalue DESC")
    @mediumlisting = Event.find(:all,:conditions => ['difficulty=?',"MEDIUM"],:order => "eventstart,pointvalue DESC")
    @easylisting = Event.find(:all,:conditions => ['difficulty=?',"EASY"],:order => "eventstart,pointvalue DESC")
=begin
    @listing = Event.find(:all,:order=>"CASE
    WHEN difficulty='HARD' THEN 1
    WHEN difficulty='MEDIUM' THEN 2
    WHEN difficulty='EASY' THEN 3
    ELSE 4
  END, pointvalue DESC, eventstart")
    session[:volunteergate] = "all"
=end
  end
  def seesignups
    @pagetitle = "Your Signups &ndash; WalnutNHS".html_safe
    @listsignups = Signup.find(:all,:conditions => ['account_id = ? AND status != ?',$user.id,"COMPLETE"], :order => "CASE
    WHEN status='VOLUNTEER' THEN 1
    WHEN status='WAITLIST' THEN 2
    WHEN status='ABSENT' THEN 3
    ELSE 4
  END, created_at")
  end
end
def geteventdesc(e)
	if e[:donation]
		return '<span style="color:#666;">[Donation]</span>'.html_safe
	elsif e[:eventend] < Time.zone.now
		return '<span style="color:#666;">[Event is over.]</span>'.html_safe
	elsif e[:eventstart] >= Time.zone.now && e.signupperiod?
		return '<span style="color:#568800;">Upcoming, signups open.</span>'.html_safe
	elsif e[:eventstart] >= Time.zone.now && !e.signupperiod?
		return '<span style="color:#30307D;">[Upcoming, signups closed.]</span>'.html_safe
	else
		return ""
	end
end