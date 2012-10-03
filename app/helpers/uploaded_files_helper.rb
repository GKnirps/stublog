module UploadedFilesHelper
	def file_directory
		'hosted_files'
	end
	
	def save_upload(uploaded_io)
		name = uploaded_io.original_filename
		begin
			File.open(Rails.root.join(file_directory, name), "w") do |file|
				file.write(uploaded_io.read)
			end
		rescue
			return false
		end
		return true
			
	end
end
