class ApplicationController < ActionController::Base
  protect_from_forgery

  #SessionHelper: functions to log in, out, see if someone is logged in etc.
  include SessionsHelper

  #HostedFilesHelper: functions to save files etc.
  include HostedFilesHelper

  after_filter :set_headers

  def set_headers
    response.headers["x-clacks-overhead"] = "GNU Terry Pratchett";
    #TODO: Log if content security has been violated
    response.header["content-security-policy"] = "default-src 'none'; style-src 'self'; img-src *; frame-ancestors 'none';"
    response.header["Referrer-Policy"] = "same-origin"
  end
end
