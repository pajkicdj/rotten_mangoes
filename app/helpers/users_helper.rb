module UsersHelper
  def can_switch(id)
    id != session[:admin_id]
  end
end
