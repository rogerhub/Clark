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
  def new_comment(p)
	@target = p
	@listing = p.event
	@poster = p.account

	chairs = @listing.chairpeople.split(',')
    chaircondition = ""
    chairs.length.times{chaircondition += "id = ? OR "}
    chaircondition.slice!(-4,4)
    chaircondition += "1=2 " if @listing.chairpeople.blank?

    chairresult = Account.find(:all,:select => [:id,:name],:conditions => [chaircondition]|chairs,:order=>:name )
    chairresult.each do |cha|
		unless (cha.id == @poster.id) do
			@cha = cha
			mail(:to => cha.email,
				 :from => "The NHS Robot <#{Setting.find_by_name("nhsemail").value}>",
				 :subject => "Posting on #{@listing.name}")
		end
    end

  end
end

@@levelone = "thisGETSridOFrainbowTABLES"
def hash_password(password)
  Digest::SHA512.hexdigest(password+@@levelone)
end