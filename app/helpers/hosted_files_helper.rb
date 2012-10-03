module HostedFilesHelper
	def file_directory
		'hosted_files'
	end
	
	def save_upload(uploaded_io)
		name = uploaded_io.original_filename
		path = Rails.root.join(file_directory, name)
		Dir.mkdir(Rails.root.join(file_directory)) unless Dir.exists?(Rails.root.join(file_directory))
		begin
			File.open(path, "w+b") do |file|
				file.write(uploaded_io.read)
			end
		rescue
			FileUtils.rm(path) if File.exists?(path)
			return false
			raise if Rails.env.development?
		end
		return true
			
	end

	def delete_file(name)
		path = Rails.root.join(file_directory, name)
		FileUtils.rm(path)
	end
end
