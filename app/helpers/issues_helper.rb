module IssuesHelper

class CurrentYear
	attr :current_year
	def initialize()
		@current_year = -1
	end
	
	def add_new_row_on_change_of_year(this_year)
		html_txt = ""
		
		if this_year != @current_year
			html_txt = " </tr>\n" unless @current_year == -1
			html_txt = html_txt + "<tr><th> #{this_year}</th> "
			@current_year = this_year
		end
		return html_txt.html_safe
	end
end

		
end
