require "digest/sha2"

@@levelone = "thisGETSridOFrainbowTABLES"
def hash_password(password)
  Digest::SHA512.hexdigest(password+@@levelone)
end

class SettingsController < ApplicationController
  before_filter :getuser,:settab
  before_filter :req_loggedin, :only => [:index,:changecontact,:firstlogin,:profilecheck,:uploadpicture,:changeemail,:changephone,:changeprivacy,:changepassword,:logoutall]
  before_filter :req_post, :only => [:changecontact,:profilecheck,:uploadpicture,:changeemail,:changephone,:changeprivacy,:changepassword,:logoutall]
  def settab    
    #@activetab = "account"
    @pagetitle = "Settings &ndash; WalnutNHS".html_safe
  end
  def req_loggedin
    return render :text => "You must be logged in to see this page.#{goback}" if !isloggedin?
  end
  def req_post
    return render :text => "Only POST requests are accepted.#{goback}" if !request.post?
  end
  def index
    
  end
  def firstlogin
    if !$user.comments.blank? || ($user.comments.include? "initdone")
     return render :text => "The profile has already been checked. <a href='/'>Click here</a> to continue."
    end
    render "firstlogin", :layout => "loginform"
  end
  def profilecheck
    if !$user.comments.blank? || ($user.comments.include? "initdone")
     return render :text => "The profile has already been checked. <a href='/'>Click here</a> to continue."
    end
    if %r(^[0-9]{4}$).match(params[:fl_year])
      $user.update_attributes(:year => params[:fl_year])
    end
    $user.update_attributes(:name => params[:fl_name],:telephone => params[:fl_telephone],:email => params[:fl_email])
    
    if !params[:fl_newpassword].blank?
      if params[:fl_oldpassword] != $user.password
        return render :text => "The old password did not match the database. Go back and try again."
      else
        $user.update_attributes(:password => params[:fl_newpassword])
      end
    end
    $user.update_attributes(:comments => $user.comments + "initdone")
    session[:return_to] = "/"
    redirect_to "/login/success"
  end
  def uploadpicture
    if params[:deletepicture] == "deleteit"
      File.delete("#{RAILS_ROOT}/public" + $user.picturepath) if $user.haspicture
      
      session[:message] = "Your profie picture has been removed."
      return redirect_to "/settings"
    end
    filex = ""
    if params[:profilepic].content_type == "image/png"
      filex = ".png"
    elsif params[:profilepic].content_type == "image/jpeg"
      filex = ".jpg"
    else
      return render :text => "Unknown mime type for picture.#{goback}"
    end
    finalpath = Rails.root.join("public","pictures","#{$user.id}#{filex}")
    
    `convert "#{addslashes(Rails.root.join(params[:profilepic].tempfile.path).to_s)}" -resize 256x256^ -gravity center -extent 256x256 "#{finalpath}"`
    
    session[:message] = "Your profie picture has been changed."
    redirect_to "/settings"
  end
  def changecontact
    $user.update_attributes(:contact => params[:contactinfo].strip)
    session[:message] = "Your contact information has been changed."
    redirect_to "/settings"
  end
  def changeemail
    $user.update_attributes(:email => params[:newemail].strip)
    session[:message] = "Your email has been changed."
    redirect_to "/settings"
  end
  def changephone
    $user.update_attributes(:telephone => params[:newphone].strip)
    session[:message] = "Your phone number has been changed."
    redirect_to "/settings"    
  end
  def changeprivacy
    if params[:privacy] == "private"
      $user.update_attributes(:privacy => 0)
    elsif params[:privacy] == "semi"
      $user.update_attributes(:privacy => 1)
    elsif params[:privacy] == "public"
      $user.update_attributes(:privacy => 2)
    else
      $user.update_attributes(:privacy => 0)
    end
    session[:message] = "Your privacy setting has been changed."
    redirect_to "/settings"
  end
  def changepassword
    return render :text => "Wrong old password inputted.#{goback}" if $user.password != params[:cpwold] #no hash here
    # return render :text => "Your new password is too short." if params[:cpwnew].length < 6
    #whoops sorry, can't enforce this on a hashed password. i'll just do it client sided and leave it up to the user.
    $user.update_attributes(:password => params[:cpwnew],:rememberhash => "") #no hash here either.. i guess
    session[:message] = "Your password has been changed."
    redirect_to "/settings"
  end
  def logoutall
    authhash = generate_challenge()
    $user.update_attributes(:sessionhash => authhash,:rememberhash => "",:resethash => "") #kil EVERYTHING
    session[:auth_registeredhash] = authhash
    session[:message] = "You have been logged out of all other sessions."
    redirect_to "/settings"
  end  
end