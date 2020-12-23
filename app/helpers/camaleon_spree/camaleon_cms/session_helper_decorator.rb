# update camaleon session routes
module CamaleonSpree::CamaleonCms::SessionHelperDecorator
  def cama_current_user
    @cama_current_user ||= lambda{
      if spree_current_user.try(:id).present?
        spree_current_user.decorate
      end
    }.call
  end

  def cama_admin_login_path
    spree_login_path
  end
  alias_method :cama_admin_login_url, :cama_admin_login_path

  def cama_admin_register_path
    spree_signup_path
  end
  alias_method :cama_admin_register_url, :cama_admin_register_path

  def cama_admin_logout_path
    spree_logout_path
  end
  alias_method :cama_admin_logout_url, :cama_admin_logout_path
end

::CamaleonCms::SessionHelper.prepend(CamaleonSpree::CamaleonCms::SessionHelperDecorator)
