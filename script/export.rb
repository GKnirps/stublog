# run it with bundle exec rails runner

def html_whitelist(html)
  html = Sanitize.fragment(html,
    elements: ['a', 'ol', 'ul', 'li', 'dl', 'dt', 'dd' 'br', 'p', 'div', 'strong', 'em', 'table', 'th', 'tr', 'h3', 'h4', 'h5', 'img', 'blockquote', 'br'],
    attributes: {
      'img' => ['src', 'alt', 'title'],
      'a' => ['href'],
      'table' => ['border'],
      'blockquote' => ['cite']
    },
    protocols: {
      'a' => {'href' => ['http', 'https', 'mailto']},
      'img' => {'img' => ['http', 'https']}
    }
  )
  html.html_safe
end

def write_blogpost(fname, blogpost)
  File.open(fname, mode="w") do |file|
    file.puts("---")
    file.puts("title: %s" % blogpost.caption)
    file.puts("filename: %d" % blogpost.id)
    file.puts("date: %s" % blogpost.created_at.iso8601)
    file.puts("tags: %s" % blogpost.tagstring)
    file.puts("allow-html: true")
    file.puts("---\n")

    file.puts("### %s\n" % blogpost.caption)
    file.puts(html_whitelist(blogpost.content))
  end
end

def write_blogposts(main_path)
  blogposts_path = main_path + "/blogposts"
  if !File.directory? blogposts_path then
    Dir.mkdir(blogposts_path)
  end
  
  Blogpost.all.each do |blogpost|
    filename = "%s/%s__%04d.md" % [blogposts_path, blogpost.created_at.strftime("%Y-%m-%dT%H:%M"), blogpost.id]
    write_blogpost(filename, blogpost)
    puts("written %s" % filename)
  end
end

if ARGV.size != 1 then
  puts("Expected exactly one argument: A destination directory")
  exit(1)
end

write_blogposts(ARGV[0])
