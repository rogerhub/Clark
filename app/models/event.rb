class Event < ActiveRecord::Base
  has_many :accounts, :through => :signups
  before_destroy {|evt| Signup.destroy_all(:event_id => evt.id)}
  def event_path
    return "/volunteer/event/#{id}/#{name.gsub(/[^a-zA-Z0-9]+/,'-')}"
  end
  def ongoing?
    Time.now<eventend.to_datetime && Time.now > eventstart.to_datetime
  end
  def signupperiod?
    Time.now<signupend.to_datetime && Time.now > signupstart.to_datetime
  end
  def active?
    Time.now<activeend.to_datetime && Time.now > activestart.to_datetime
  end
  def htmldescription
    return processtags description
  end
  def htmlsynopsis
    return processtags synopsis
  end
  def pointdifficulty
    "#{pointvalue} #{difficulty.capitalize()}"
  end
  def basename
    name.gsub(/\(.+\)/,"").strip
  end

  def processtags (i)

	ret = hsc(i)

    ret.gsub!(/http:\/\/\S+/,"<a href=\"\\0\">\\0</a>")

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

    if ret.include?('%CHAIRPEOPLE%') && (!chairpeople.blank?) #don't want to do this costly operation if there is no tag
      chairs = chairpeople.split(',')
      chaircondition = ""
      chairs.length.times{chaircondition += "id = ? OR "}
      chaircondition.slice!(-4,4)
      chaircondition += "1=2 " if chairpeople.blank?

      chairdata = []
      chairresult = Account.find(:all,:select => [:id,:name],:conditions => [chaircondition]|chairs,:order=>:name )
      chairresult.each do |cha|
        chairdata |= ['<a href="'+cha.account_path.to_s+'">'+cha.name+'</a>']
      end

      ret.gsub! '%CHAIRPEOPLE%',chairdata.join(', ')
    end
    ret.gsub("\n", "<br />").html_safe
  end
end
