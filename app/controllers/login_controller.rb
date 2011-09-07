class LoginController < ApplicationController
  
  before_filter :getuser,:settab
  def settab    
    @activetab = "login"
    @pagetitle = "Login &ndash; WalnutNHS".html_safe
  end
  
  def index    
    return redirect_to "/" if isloggedin?
    session[:return_to] = request.referer if !request.referer.include? "login"
    @pagedescription = "Login to the WalnutNHS website in order to see points, signup for events, and search for fellow NHS members."
    @pagekeywords = "login, signin, WalnutNHS, Walnut, National Honor Society, Walnut High, Walnut High School"
    render "index", :layout => "loginform"
  end
  def forgot    
    return redirect_to "/" if isloggedin?
    @pagetitle = "Forgot password &ndash; WalnutNHS".html_safe
    @pagedescription = "Recover your password by email for the WalnutNHS website."
    @pagekeywords = "forgot, password, WalnutNHS, Walnut, National Honor Society, Walnut High, Walnut High School"
  end
  def forgottendo
    return redirect_to "/" if isloggedin?
    if params[:forgot_studentid].blank?
      return render :text => "You need to enter a student id."
    end
    target_user = Account.find(:first,['studentid = ?',params[:forgot_studentid]])
    return render :text => "No account with that student id was found.#{goback}" if target_user.blank?
    NhsMailer.forgot_email(target_user).deliver
    return render :text => "A email has been sent to your email address. Please check your email and follow the instructions. <a href='/login'>Back to login page.</a>"
  end
  def reset
    return render :text => "You are already logged in! Log out before resetting a password.#{goback}" if isloggedin?
    return render :text => "The hash provided is invalid. Maybe you copied the link wrong? Uhoh.#{goback}" if params[:hp].blank? || params[:hp].length < 6
    target_user = Account.find_by_resethash(hash_password(params[:hp]))
    return render :text => "The hash provided has expired. Please go and request another password reset email.#{goback}" if target_user.blank?
    @hashval = params[:hp]
  end
  def resetdo
    return render :text => "You are already logged in! Log out before resetting a password.#{goback}" if isloggedin?
    return render :text => "The hash provided is invalid. Maybe you copied the link wrong? Uhoh.#{goback}" if params[:rd_hash].length < 6
    target_user = Account.find_by_resethash(hash_password(params[:rd_hash]))
    return render :text => "The hash provided has expired. Please go and request another password reset email.#{goback}" if target_user.blank?
    
    target_user.update_attributes(:password => params[:rd_newpassword],:resethash => "")
    session[:reset_success] = true
    redirect_to "/login"
  end
  def do #bad coding practice, i know
    return redirect_to "/" if isloggedin?
    @pagetitle = "Logging in..".html_safe
    key = session[:challenge_key] || ""
    accountresult = Account.find(:first,:conditions=>["studentid = ?",params[:sl_studentid]]) || nil
    
    if (key.length != 40)      
      session[:login_error] = true
    elsif (!(%r(^[0-9]{1,8}$).match(params[:sl_studentid])))
      session[:login_error] = true
    elsif (accountresult.blank?)
      session[:login_error] = true
    elsif (hash_challenge(params[:sl_challenge],key) != params[:sl_challengehash])
      session[:login_error] = true
      # Using regex to take out nonsense newlines. I don't know why they appear.
    elsif (hash_auth(accountresult[:password].gsub(/[^a-fA-F0-9]/,""),params[:sl_challenge]) != params[:sl_superhash])
   
      session[:login_error] = true
    else
      if params[:sl_remember] == "remember"
        randres = generate_challenge()
        cookies[:clark_hash] = {:value => randres, :expires => 1.month.from_now.utc }
        accountresult.update_attributes(:rememberhash => hash_cookie(randres))
      else
        cookies.delete(:clark_hash) # in case of residual cookie
      end
      
      if accountresult.sessionhash.blank?
        authhash = generate_challenge()
        acccountresult.update_attributes(:sessionhash => authhash)
        session[:auth_registeredhash] = authhash
      else
        session[:auth_registeredhash] = accountresult.sessionhash
      end
      
      session[:login_error] = false
      session[:login_success] = true
      session[:auth_registeredid] = accountresult[:id]
      session[:auth_registeredip] = request.remote_ip
    end
    if (session[:login_error])
      #record "LOGIN_ERROR #{params[:sl_studentid]}", "IP: #{request.host}"
     # sleep 2 #rate limiting ROFLS
      redirect_to "/login"
    else 
      #record "LOGIN_SUCCESS STUDENTID#{params[:sl_studentid]}", "IP: #{request.host}"
      if !(!(accountresult.comments.blank?) && accountresult.comments.include? ("initdone"))
        redirect_to "/settings/firstlogin"
      else
        #redirect_to(session[:return_to] || "/")#root_path
        redirect_to "/login/success"
      end
    end
  end
  def success
    congratulate = "myself for such a job well done!"
    @urltarget = session[:return_to] || "/"
    render "success",:layout => "redirect"
  end
  def out
    if isloggedin?
      $user.update_attributes(:rememberhash => "") # logging out clears the remember hash? well... okay
    end
    @pagetitle = "Logging out..".html_safe
    #record "LOGOUT #{session[:auth_registeredid]}", "IP: #{request.host}"
    session[:auth_registeredid] = nil
    session[:auth_registeredip] = nil
    session[:auth_registeredhash] = nil
    session[:login_out] = true
    cookies.delete(:clark_hash)
    redirect_to "/login"
  end
end

require "digest/sha2"
@@levelone = "thisGETSridOFrainbowTABLES"
@@leveltwo = "xREGQnyuog4fNwTUmSUGqUC6sFZT63oaJiYW9im4"
def generate_challengekey()
  if (!defined? session[:challenge_key] || session[:challenge_key].length != 40)
    c='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
    p=''
    40.times{p << c[rand(c.length)]}
    session[:challenge_key] = p
  end
  session[:challenge_key]
end

def generate_challenge()
  c='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
  p=''
  20.times{p << c[rand(c.length)]}
  p
end
def get_level_one()
  @@levelone
end
def hash_challenge(challenge,key)
  puts challenge
  Digest::SHA512.hexdigest(challenge+key)
end
def hash_auth(password,challenge)
  Digest::SHA512.hexdigest(password+challenge)
end
def hash_password(password)
  Digest::SHA512.hexdigest(password+@@levelone)
end
def hash_cookie(salt)
  Digest::SHA512.hexdigest("#{salt}#{request.host}#{@@levelone}")
end