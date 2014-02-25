class UserMailer < ActionMailer::Base

  def registration_confirmation(user) 
  	@user = user
    mail(:from => "stepofchange.vlad@gmail.com", :to => user.email, :subject => "Thank you for registration")
  end

end
