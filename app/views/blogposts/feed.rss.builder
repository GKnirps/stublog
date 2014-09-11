xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Stranger than usual"
    xml.description "Ich bin nicht normal. Ich bin merkwürdiger als normal"
    xml.link blogposts_url

    for blogpost in @blogposts
      xml.item do
        xml.title blogpost.caption
        xml.description Sanitize.fragment blogpost.content
        xml.pubDate blogpost.created_at.to_s(:rfc822)
        xml.link blogpost_url(blogpost)
        xml.guid blogpost_url(blogpost)
      end
    end
  end
end 
