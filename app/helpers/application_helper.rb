module ApplicationHelper

  def get_page_number more_link
    /\d/.match(more_link).to_s.to_i - 1
  end
end
