class PeopleController < ApplicationController
  before_filter :getuser,:settab
  def settab
    @activetab = "people"
    @pagedescription = "The complete list of NHS members in Walnut High School's chapter of the National Honor Society: WalnutNHS."
    @pagekeywords = "people, members, club, directory, list, WalnutNHS, Walnut, National Honor Society, Walnut High, Walnut High School"
  end
  def bypass
  	cookies[:bypass]="preview"
    redirect_to "/"
  end
  def index
    @pagetitle = "People &ndash; WalnutNHS".html_safe
    @allmembers = Account.find(:all, :conditions => ["privileges != 'ADVISOR'"], :order => "name")
    @board = Account.find(:all, :conditions => ["privileges IN ('OFFICER','SUPEROFFICER','ADMINISTRATOR')"],
    :order=>"CASE
      WHEN privileges='ADVISOR' THEN 1
      WHEN LOWER(title)='advisor' THEN 1
      WHEN LOWER(title)='president' THEN 2
      WHEN LOWER(title) LIKE '%vice president%' THEN 3
      WHEN LOWER(title)='secretary' THEN 4
      WHEN LOWER(title)='treasurer' THEN 5
      WHEN LOWER(title)='parliamentarian' THEN 6
      WHEN LOWER(title)='historian' THEN 7
      WHEN LOWER(title)='webmaster' THEN 8
      WHEN LOWER(title)='cabinet' THEN 9
      ELSE 100
    END, name")
    @membercount = @allmembers.size
    @pointtotal = Signup.sum(:pointvalue)
    @eventcount = Event.find(:all).size
    @signupcount = Signup.find(:all).size
    @peoplemotivation = $clarksettings[:peoplemotivation] || ""
  end
  def profile
    return render :text => "You are not logged in!#{goback}" if !isloggedin?
    redirect_to $user.account_path
  end
  def showvolunteer
    if !params[:q].blank?
		allaccounts = Account.find(:all)
		allaccounts.each do |act|
			if act.c14n == params[:q]
				params[:account_id] = act.id
			end
		end

    end
    return render :text => "Invalid account id.#{goback}" if !params[:account_id].to_s.match(/^[0-9]+$/)
    @member = Account.find(params[:account_id],:include => [:group,:signups])
    return render :text => "Could not find that account.#{goback}" if @member.blank?
    @pagetitle = "#{@member.name}'s Profile &ndash; WalnutNHS".html_safe
    @pagedescription = "#{@member.name}'s volunteer profile, including #{@member.name}'s points, volunteer record, and contact information."
    @pagekeywords = "#{@member.name}, people, members, club, directory, list, WalnutNHS, Walnut, National Honor Society, Walnut High, Walnut High School"
    currentsemester = $clarksettings[:currentsemester]
    @membersignups = Signup.find(:all,:include => :event,:conditions => ["account_id = ?",params[:account_id]],:order=>ActiveRecord::Base.send(
"sanitize_sql_array", ["CASE
    WHEN semester != ? THEN 2
    ELSE 1
    END
    ,CASE
    WHEN difficulty='PENALTY' THEN 6
    WHEN status='VOLUNTEER' THEN 1
    WHEN status='WAITLIST' THEN 2
    WHEN status='COMPLETE' THEN 3
    WHEN status='DENIED' THEN 4
    WHEN status='ABSENT' THEN 5
    ELSE 7
  END, completiondate DESC",currentsemester]))

    @totalpoints = @member.signups.sum(:pointvalue)
    @currentsemester = $clarksettings[:currentsemester] || ""
    @tumblrurl = $clarksettings[:tumblrurl] || ""

	semesterlist_pre = $clarksettings[:semesterlist] || ""
    @semesterlist = semesterlist_pre.split("\n").map!{|item| item.strip}
    @sem_points = {}
    @semesterlist.each do |sem|
		@sem_points[sem] = @member.signups.where(:semester => sem).sum(:pointvalue)
    end

    @pointsthissemester = @member.signups.where(:semester => @currentsemester).sum(:pointvalue)
    @completedevents = Signup.count(:conditions => ['account_id = ? AND status = ? AND difficulty != ?',@member.id,"COMPLETE","PENALTY"])
    @waitlistevents = Signup.count(:conditions => ['account_id = ? AND status = ?',@member.id,"WAITLIST"])
    @volunteeredevents = Signup.count(:conditions => ['account_id = ? AND status = ?',@member.id,"VOLUNTEER"])

    @hardevents = Signup.count(:conditions => ['account_id = ? AND status = ? AND difficulty = ? AND semester = ?',@member.id,"COMPLETE","HARD",@currentsemester])
    @mediumevents = Signup.count(:conditions => ['account_id = ? AND status = ? AND difficulty = ? AND semester = ?',@member.id,"COMPLETE","MEDIUM",@currentsemester])
    @easyevents = Signup.count(:conditions => ['account_id = ? AND status = ? AND difficulty = ? AND semester = ?',@member.id,"COMPLETE","EASY",@currentsemester])


    @violations = 0
    @violations += 1 if @pointsthissemester < 25
    @violations += 1 if @hardevents < 2
    @violations += 1 if @mediumevents.to_i + [0,@hardevents-2].max.to_i < 2
    @violations += 1 if @easyevents.to_i + [0,@mediumevents.to_i + [0,@hardevents-2].max.to_i - 2].max.to_i < 2


    #sorry this is so messy. so much for DRY
    @completedevents = "none" if @completedevents == 0
    @waitlistevents = "none" if @waitlistevents == 0
    @volunteeredevents = "none" if @volunteeredevents == 0
    @hardevents = "none" if @hardevents == 0
    @mediumevents = "none" if @mediumevents == 0
    @easyevents = "none" if @easyevents == 0

    @groupsenabled = $clarkconfigjson['groups'] == "enabled"

    if !@member.group_id.blank?
    @groupleader = @member.group.leader
    @groupmembers = @member.group.members
    end

    @allmyhours = 0;
    myhours = Signup.find(:all,:conditions => ["signups.account_id = ? AND events.donation = ? AND signups.status = ? AND signups.difficulty != ?",@member.id,false,"COMPLETE","PENALTY"],:include => :events);
    myhours.each do |hh|
		@allmyhours += (hh.event.eventend - hh.event.eventstart).to_f / 3600
    end
  end
end