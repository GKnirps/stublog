class ApplicationController < ActionController::Base
  protect_from_forgery

  #SessionHelper: functions to log in, out, see if someone is logged in etc.
  include SessionsHelper

  #HostedFilesHelper: functions to save files etc.
  include HostedFilesHelper

  after_filter :schmutz

  def schmutz
    today = Date.today
    if today.day == 1 and today.month == 4 then
      if response.content_type and response.content_type.match('^text/html') then
        response.body = spillDirt(Nokogiri::HTML(response.body))
      end
    end
  end
  
  def spillDirt(dom)
    title = dom.at_xpath("//head/title")
    title.content = mangle(title.content, $DIRT[1], 0.3)
    body = dom.at_xpath("//body")
    recursiveSpillDirt(body)
    dom.to_html
  end

  def recursiveSpillDirt(node)
    children = node.children
    children.each do |child|
      if child.text? and child.content and not child.content.match /^\s*$/ then
        child.content = mangle(child.content.lstrip, $DIRT[1], 0.3)
      else
        recursiveSpillDirt(child)
      end
    end
  end
end
