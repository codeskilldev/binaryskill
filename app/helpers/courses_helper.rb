module CoursesHelper

	def crop (string, length)
		s = string 
		i = length
		if s.length > i
			while s[i] != ' '
				i -= 1
			end
		else
			return s
		end
		return s.slice(0, i) + '...' 
	end


	def print_options(list)
		result = "<option></option>"
		list.each do |u|
			result += "<option value=#{u.id}>#{u.name}</option>"
		end
		return result
	end

end
