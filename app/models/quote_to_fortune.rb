#Class that makes a fortune databank out of the published quotes of the day
class QuoteToFortune
	#make a fortune db file string out of the published quotes
	def quotelist()
		#old variant: put url and description into the fortune databank. This is ugly for fortune.
		#@quotelist ||= QuoteOfTheDay.published.map { 
		#	|q| [q.sourcedesc, q.sourceurl, q.content].compact.select{|a| a != ""}.join("\n") }.join("\n%\n")
		@quotelist ||=QuoteOfTheDay.published.map{|q| Sanitize.fragment(q.content)}.join "\n%\n"
		
	end
	
	#return file path to the .tar.gz fortune archive
	def fortune_archive_path()
		path = "/tmp/stublog/fortune"
		archive_name = File.join path, fortune_name
		#if there is already an up-to-date archive, take this one
		if File.exists? archive_name then
			return archive_name
		end
		#otherwise create a new one and remove the old one, or create the path if necessary
		if Dir.exists? path then
			Dir.open path do |d|
				d.each { |f| File.delete File.join(path, f) if File.file? File.join(path, f)}
			end
		elsif not Dir.exists? "/tmp/stublog" then
			Dir.mkdir "/tmp/stublog"
			Dir.mkdir path
		else
			Dir.mkdir path
		end
		create_fortune_archive(path)

		return archive_name
	end

	#create new fortune archive in the given path
	def create_fortune_archive(path)
		#write quotelist to a file
		f = File.open(File.join(path, "stublog"), "w")
		f.write(quotelist)
		f.close
		#create the .dat file
		`strfile #{File.join(path, "stublog")}`
		#create the tar archive
		`tar --directory #{path} -cvzf #{File.join(path, fortune_name)} stublog stublog.dat`
	end

	#returns filename for the archive based on the newest published quote's date and id
	def fortune_name()
		q ||= QuoteOfTheDay.published.first
		@fname ||= "stublog_fortune_#{q.id}_#{q.updated_at.strftime "%Y-%m-%d"}.tar.gz"
	end
end
