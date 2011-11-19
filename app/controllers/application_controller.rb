$version = "2.11 beta"
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :getanalytics,:checkmaintenance
  def record(description,content)
    #File.open(Rails.root.join('log/record.log'), 'a') {|f| f.write(Time.new.to_f.to_s + " -- " + description + " -- " + content + "\n")}
  end

end
def checkmaintenance
  maintain_on = Setting.find_by_name('maintenance').value || "off"
  
  clarkconfig = ActiveSupport::JSON.decode(File.open(Rails.root.join("clarkconfig.json"), "r").read)
  
  if maintain_on == "on" && !clarkconfig['maintenance_ip'].include?(request.remote_ip) && cookies[:bypass] != "preview" && !request.request_uri.include?("bypass")
    render :status => 503, :text => "",:layout => "maintenance"
  end
  
  $blogurl = Setting.find_by_name("tumblrurl").value
end
def getanalytics
  clarkconfig = ActiveSupport::JSON.decode(File.open(Rails.root.join("clarkconfig.json"), "r").read)
  $analyticscode = clarkconfig['analytics'] || ""
end
def isloggedin?
  return true if (request.remote_ip == session[:auth_registeredip]) && (session[:auth_registeredid]) && (session[:auth_registeredhash] == Account.find(session[:auth_registeredid]).sessionhash)
  if (!cookies[:clark_hash].blank? && u=Account.find_by_rememberhash(hash_cookie(cookies[:clark_hash])))
  #this only executes if the above does not quit the function
    return false if u.rememberhash.length < 20 #no idea

    randres = generate_challenge()
    cookies[:clark_hash] = {:value => randres, :expires => 1.month.from_now.utc }
    u.update_attributes(:rememberhash => hash_cookie(randres))

    session[:auth_registeredip] = request.host
    session[:auth_registeredid] = u.id
    return true
  end
  return false
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
def goback
  ' <a href="javascript:history.go(-1);">Go back</a> and try again.'
end
def addslashes(str)
  str.gsub(/['"\\\x0]/,'\\\\\0')
end

def stripslashes(str)
  str.gsub(/\\(.)/,'\1')
end
