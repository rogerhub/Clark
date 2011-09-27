class PeopleController < ApplicationController
  before_filter :getuser,:settab
  def settab    
    @activetab = "people"
    @pagedescription = "The complete list of NHS members in Walnut High School's chapter of the National Honor Society: WalnutNHS."
    @pagekeywords = "people, members, club, directory, list, WalnutNHS, Walnut, National Honor Society, Walnut High, Walnut High School"
  end
  def index
    @pagetitle = "People &ndash; WalnutNHS".html_safe
    @allmembers = Account.find(:all, :conditions => ["privileges != 'ADVISOR'"], :order => "name")
    @board = Account.find(:all, :conditions => ["privileges IN ('ADVISOR','OFFICER','SUPEROFFICER','ADMINISTRATOR')"],
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
      WHEN LOWER(title)='cabinet' THEN 8
      ELSE 100
    END, name")
    @membercount = Account.find(:all).size
    @pointtotal = Signup.sum(:pointvalue)
    @eventcount = Event.find(:all).size
    @signupcount = Signup.find(:all).size
    @peoplemotivation = Setting.find(:first, :conditions => ['name = ?','peoplemotivation']).value || ""
  end
  def profile
    return render :text => "You are not logged in!#{goback}" if !isloggedin?
    redirect_to $user.account_path
  end
  def showvolunteer
    return render :text => "Invalid account id.#{goback}" if !params[:account_id].to_s.match(/^[0-9]+$/)
    @member = Account.find(params[:account_id])
    return render :text => "Could not find that account.#{goback}" if @member.blank?
    @pagetitle = "#{@member.name}'s Profile &ndash; WalnutNHS".html_safe
    @pagedescription = "#{@member.name}'s volunteer profile, including #{@member.name}'s points, volunteer record, and contact information."
    @pagekeywords = "#{@member.name}, people, members, club, directory, list, WalnutNHS, Walnut, National Honor Society, Walnut High, Walnut High School"
    @membersignups = Signup.find(:all,:include => [:event],:conditions => ["account_id = ?",params[:account_id]],:order=>"CASE
    WHEN status='VOLUNTEER' THEN 1
    WHEN status='WAITLIST' THEN 2
    WHEN status='COMPLETE' THEN 3
    WHEN status='DENIED' THEN 4
    WHEN status='ABSENT' THEN 5
    ELSE 6
  END, completiondate DESC")
    
    @totalpoints = @member.signups.sum(:pointvalue)
    @currentsemester = Setting.find(:first, :conditions => ['name = ?','currentsemester']).value || ""
    @tumblrurl = Setting.find(:first, :conditions => ['name = ?','tumblrurl']).value || ""
    
    @pointsthissemester = @member.signups.where(:semester => @currentsemester).sum(:pointvalue)
    @completedevents = Signup.count(:conditions => ['account_id = ? AND status = ?',@member.id,"COMPLETE"])
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
    
    clarkconfig = ActiveSupport::JSON.decode(File.open(Rails.root.join("clarkconfig.json"), "r").read)
    @groupsenabled = clarkconfig['groups'] == "enabled"
    
    if !@member.group_id.blank?
    @groupleader = @member.group.leader
    @groupmembers = @member.group.members
    end
  end
end