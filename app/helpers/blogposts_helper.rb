require 'rbbcode'
module BlogpostsHelper
	#default bbcode parser (I plan to extend this one)
	def bbparse(text)
		bbparser = RbbCode::Parser.new
		bbparser.parse(text).html_safe
	end
end
