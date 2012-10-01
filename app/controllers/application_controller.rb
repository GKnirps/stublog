class ApplicationController < ActionController::Base
  protect_from_forgery

  #SessionHelper: functions to log in, out, see if someone is logged in etc.
  include SessionsHelper
end
