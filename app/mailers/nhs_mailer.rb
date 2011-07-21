class NhsMailer < ActionMailer::Base
  default :from => Setting.find(:first, :conditions => ['name = ?','nhsemail']).value || ""
  def forgot_email(user)
    @user = user
    @newpw = (0...8).map{65.+(rand(25)).chr}.join # LOL THANK YOU STACKOVERFLOW
    @user.update_attributes(:password => hash_password(@newpw))
    mail(:to => @user.email,
          :subject => "Password Recovery on WalnutNHS")
  end
end

@@levelone = "thisGETSridOFrainbowTABLES"
def hash_password(password)
  Digest::SHA512.hexdigest(password+@@levelone)
end