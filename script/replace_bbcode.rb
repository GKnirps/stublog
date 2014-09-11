require 'rbbcode'
	
#default bbcode parser (I plan to extend this one)
def bbparse(text, safe=:safe)
  #workaround: since the new version, everything is passed through the sanitizer gem
  #as result, '<' and '>' are not escaped anymore, if they appear to be part of a tag
  #so escape them right here:
  text = text.gsub(/</, "&lt;").gsub(/>/, "&gt;")
	#parse the bbcode
  bbparser = RbbCode.new
  htmlcode = bbparser.convert(text)
  return htmlcode.html_safe if safe == :safe
  return htmlcode
end

quotes = QuoteOfTheDay.all

quotes.each do |quote|
  quote.content = bbparse(quote.content)
  quote.save
end

posts = Blogpost.all

posts.each do |post|
  post.content = bbparse(post.content)
  post.save
end

categories = Category.all

categories.each do |category|
  category.description = bbparse(category.description)
  category.save
end

comments = Comment.all

comments.each do |comment|
  comment.content = bbparse(comment.content)
  comment.save
end
