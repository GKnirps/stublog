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
    if blogpost.updated_at and blogpost.updated_at != blogpost.created_at then
      file.puts("update-date: %s" % blogpost.updated_at.iso8601)
    end
    file.puts("tags: %s" % blogpost.tagstring)
    if blogpost.category then
      file.puts("category: %s" % normalize_cat_name(blogpost.category.name))
    end
    file.puts("allow-html: true")
    file.puts("---\n")

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

def normalize_cat_name(name)
  # the umlaut normalization is kind of crude, but we only have one dataset to export,
  # so it should be sufficient
  name.downcase.gsub(" ", "_").gsub("ö", "oe").gsub("ü", "ue").gsub("ä", "ae")
end

def write_category(fname, category)
  File.open(fname, mode="w") do |file|
    file.puts("---")
    file.puts("path-name: %s" % normalize_cat_name(category.name))
    file.puts("title: %s" % category.name)
    # I intend to use a normalized category name as path name, but for backwards compatibility, we may
    # want to install redirects to the old urls.
    file.puts("old-id: %d" % category.id)
    file.puts("---\n")
    # Note: in the static stublog renderer, html in the description will be escaped,
    # so the description may need to be adjusted to commonmark.
    # We still won't remove the html here, so we can see what the original formatting was.
    file.puts(html_whitelist(category.description))
  end
end

def write_categories(main_path)
  categories_path = main_path + "/categories"
  if !File.directory? categories_path then
    Dir.mkdir(categories_path)
  end

  Category.all.each do |category|
    filename = "%s/%s.md" % [categories_path, normalize_cat_name(category.name)]
    write_category(filename, category)
    puts("written %s" % filename)
  end
end

def write_hosted_file(fname, hosted_file)
  if !hosted_file.public then
    puts "Hosted file #%d (%s) is not public" % [hosted_file.id, hosted_file.name]
    return
  end
  File.open(fname, mode="w") do |file|
    file.puts("---")
    file.puts("old-id: %d" % hosted_file.id)
    file.puts("path: %s" % hosted_file.name)
    file.puts("mime-type: %s" % hosted_file.mime_type)
    file.puts("---")
    file.puts(html_whitelist(hosted_file.description))
  end
end

def write_hosted_files(main_path)
  hosted_files_path = main_path + "/files"
  if !File.directory? hosted_files_path then
    Dir.mkdir(hosted_files_path)
  end

  HostedFile.all.each do |hosted_file|
    filename = "%s/%s__%s.md" % [hosted_files_path, hosted_file.created_at.strftime("%Y-%m-%dT%H:%M"), File.basename(hosted_file.name, File.extname(hosted_file.name))]
    write_hosted_file(filename, hosted_file)
    puts("written %s" % filename)
  end
end

if ARGV.size != 1 then
  puts("Expected exactly one argument: A destination directory")
  exit(1)
end

write_blogposts(ARGV[0])
write_categories(ARGV[0])
write_hosted_files(ARGV[0])
