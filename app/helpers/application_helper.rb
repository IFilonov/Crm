module ApplicationHelper
  def vue_pack
    if current_client
      'client_vue'
    elsif current_staff
      'staff_vue'
    else
      'application'
    end
  end
end
