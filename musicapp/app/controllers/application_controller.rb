class ApplicationController < ActionController::Base
  helper_method :current_user

  def login_user!(user)
    @current_user = user
    session[:session_token] = user.session_token
  end

  def current_user
    return nil unless session[:session_token]
    @current_user ||= User.find_by(session_token: session[:session_token])
  end




  def logout!
    current_user.reset_session_token!
    #session[:session_token] determines whether or not there is a session occuring
    #when reset session[:session_token] to nil, the
    #current_user method now returns nil!!
    session[:session_token] = nil
  end

  def logged_in?
    !current_user.nil?
  end

  
end
