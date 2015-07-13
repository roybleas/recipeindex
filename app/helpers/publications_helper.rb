module PublicationsHelper

	def show_issue_line(issue)
 		if @action == :edit_user_issue 
			html_txt = check_box_tag("userissue[]" , issue.id.to_s, true_when_has_user_id(issue))
			html_txt = html_txt + " " + label_tag(issue.no.to_s) 
		else
			html_txt = link_to( issue.no.to_s, issue_path(issue) )
			if logged_in?
				html_txt =  html_txt + " <span class=\"glyphicon glyphicon-ok\"></span> ".html_safe  unless issue.user_id.nil?
			end
		end
		return html_txt.html_safe
	end
end
