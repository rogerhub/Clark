class NhsMailer < ActionMailer::Base
  def forgot_email(targetuser)
    @user = targetuser
    @randomhash = (0...8).map{65.+(rand(25)).chr}.join # LOL THANK YOU STACKOVERFLOW
    @user.update_attributes(:resethash => hash_password(@randomhash))
    
    #For security, this will be hardcoded here, but it can be changed if deployed to other schools.
    @newpwlink = "http://walnutnhs.com/login/reset?hp="+@randomhash
    
    mail(:to => @user.email,
    	 :from => "The NHS Robot <#{Setting.find_by_name("nhsemail").value}>",
         :subject => "Password Recovery on WalnutNHS")
  end
end

@@levelone = "thisGETSridOFrainbowTABLES"
def hash_password(password)
  Digest::SHA512.hexdigest(password+@@levelone)
end