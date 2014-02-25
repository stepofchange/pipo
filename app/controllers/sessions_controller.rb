class SessionsController < ApplicationController
  def new
  end

  def create
  	user = User.find_by(email: params[:session][:email].downcase)
    if user.confirm_email == true
      if user && user.authenticate(params[:session][:password])
        sign_in user
        redirect_back_or user
      else
        flash.now[:error] = 'Invalid email/password combination'
        render 'new'
      end
    else
      flash.now[:error] = "Email is not confirmed!"
      render 'new'
    end  
  end

  def destroy
  	sign_out
    redirect_to root_url
  end
end
