$version = "2.10 beta"
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :checkmaintenance
  def record(description,content)
    #File.open(Rails.root.join('log/record.log'), 'a') {|f| f.write(Time.new.to_f.to_s + " -- " + description + " -- " + content + "\n")}
  end
end
def checkmaintenance
  maintain_on = Setting.find(:first, :conditions => ['name = ?','maintenance']).value || "off"
  
  clarkconfig = ActiveSupport::JSON.decode(File.open(Rails.root.join("clarkconfig.json"), "r").read)
  
  if maintain_on == "on" && !clarkconfig['maintenance_ip'].include?(request.remote_ip)
    render :status => 503, :text => "",:layout => "maintenance"
  end
end
def isloggedin?
  (request.remote_ip == session[:auth_registeredip]) && (session[:auth_registeredid])
end
def authid
  ((isloggedin?)?session[:auth_registeredid]:-1)
end
def addslashes(str)
  str.gsub(/['"\\\x0]/,'\\\\\0')
end
def getuser
  if (isloggedin?)
    $user = Account.find(authid)
  else
    $user = nil
  end
end
def hsc(s)
  CGI::escapeHTML(s.to_s)
end
def print_r(i)
  YAML::dump(i)
end
def footer
  '<table cellspacing="0"><tr><td>'+
  '<input type="text" id="googsearch" /><button type="submit" id="googgo">Search</button>'+
  '</td><td style="vertical-align:middle;">'+
        'Walnut High School<br />'+
        '400 Pierre Rd. Walnut, CA.'+
        '</td><td>'+
        'Powered by <a href="http://walnutnhs.com/dev">Clark</a> '+"#{$version}<br />"+
        'An open-source management website for NHS written by <a href="http://rogerhub.com">Roger Chen</a><br />'+
        '<a href="http://walnutnhs.com/dev">Development blog</a> - <a href="http://nhs.us/">NHS and NJHS</a> - <a href="https://github.com/rogerhub/Clark">Fork me on GitHub</a>'+
        '</td></tr>'+
        '</table>'
end